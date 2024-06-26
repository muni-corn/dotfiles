{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    functions = {
      crypt-edit = ''
        if count $argv > /dev/null
          # set temp file
          set temp (mktemp)

          if test -e $argv[1]
            # decrypt the file
            echo "decrypting file..."
            gpg --yes -o $temp -d $argv[1]
          else
            echo "$argv[1] doesn't exist, but we'll create it"
          end

          # edit it, if successful
          and begin
            $EDITOR $temp

            # re-encrypt the file
            echo "encrypting file..."
            gpg --yes -o $argv[1] -c $temp
          end

          # or, don't
          or begin
            echo "file wasn't decrypted successfully, quitting"
            return 1
          end

          # remove decrypted file
          rm -f $temp

          echo "all done!"
        else
          echo "no file given."
        end
      '';

      decrypt-folder = ''
        set folder (string replace -r '/$' "" $argv[1])
        gpg --decrypt-files $folder.tar.zst.gpg
        and tar --same-owner -xpvf $folder.tar.zst
        and rm $folder.tar.zst.gpg $folder.tar.zst
      '';

      encrypt = ''gpg -c $argv[1] && rm $argv[1]'';

      encrypt-folder = ''
        set folder (string replace -r '/$' "" $argv[1])
        tar --zstd -cvf $folder.tar.zst $folder
        and gpg -c $folder.tar.zst
        and rm -rf $folder.tar.zst $folder
      '';

      nohup = ''command nohup $argv </dev/null >/dev/null 2>&1 & disown'';

      sleep-timer = ''
        set seconds (math "$argv[1] * 60")
        for i in (seq $seconds)
          set left (math $seconds - $i)
          echo -n -e "\r\033[Kgoing to sleep in $left seconds"
          sleep 1
        end
        echo -e "\r\033[Ksweet dreams :)"
        systemctl suspend
        echo -e "\r\033[Kgood morning!"
      '';

      qr = ''
        set file (mktemp)
        qrencode $argv -o $file
        imv $file
      '';
    };

    shellAliases = {
      scanqr = ''geo=(slurp) grim -g "$geo" - | ${pkgs.zbar}/bin/zbarimg --quiet --raw PNG:- 2> /dev/null | tr -d "\n"'';
      todo = "nvim $HOME/notebook/todo.norg";
      yt = "ytfzf --thumb-viewer=imv -t";
      bonsai = ''${pkgs.cbonsai}/bin/cbonsai -li -w 10 -t 0.1 -L 50 -m'';
      cheer-me-up = ''bonsai "keep going, you're doing great"'';
      roll = "random 1";
    };

    shellAbbrs = {
      h = "himalaya";
      n = "nvim";
      q = "exit";
      f = "nnn"; # for 'files'
    };

    shellInit = ''set fish_greeting ""'';
  };
}
