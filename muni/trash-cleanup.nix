{ lib, pkgs, ... }:
let
  maxAgeDays = 30;

  # systemd-tmpfiles can't empty read-only directories (git-annex makes every
  # object directory read-only), and chmod-ing from a pre-clean step would reset
  # ctime and restart the age clock. so entries are aged by the DeletionDate
  # recorded in their trashinfo file instead, and made writable only once they
  # are already past the cutoff.
  trash-cleanup = pkgs.writeShellApplication {
    name = "trash-cleanup";
    runtimeInputs = with pkgs; [
      coreutils
      gnused
    ];
    text = ''
      max_age_days="''${1:-${toString maxAgeDays}}"
      trash="''${XDG_DATA_HOME:-$HOME/.local/share}/Trash"
      cutoff=$(date -d "$max_age_days days ago" +%s)

      shopt -s nullglob
      for info in "$trash"/info/*.trashinfo; do
        name=$(basename "$info" .trashinfo)
        deleted=$(sed -n 's/^DeletionDate=//p' "$info" | head -n 1)

        # skip entries without a readable date rather than guessing their age
        deleted_at=$(date -d "$deleted" +%s 2>/dev/null) || continue
        [ "$deleted_at" -lt "$cutoff" ] || continue

        target="$trash/files/$name"
        if [ -e "$target" ] || [ -L "$target" ]; then
          chmod -R u+rwX "$target" 2>/dev/null || true
          if ! rm -rf "$target"; then
            echo "couldn't remove '$target', does it have an immutable attribute?" >&2
            continue
          fi
        fi

        rm -f "$info"
      done
    '';
  };
in
{
  systemd.user = {
    services.trash-cleanup = {
      Unit.Description = "Empty trash entries older than ${toString maxAgeDays} days";
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe trash-cleanup;
        IOSchedulingClass = "idle";
        Slice = "background.slice";
      };
    };

    timers.trash-cleanup = {
      Unit.Description = "Daily trash cleanup";
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
