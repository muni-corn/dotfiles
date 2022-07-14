{ config, pkgs, ... }:

let
  colors = config.muse.theme.finalPalette;

  bg = colors.swatch.background;
  fg = colors.swatch.foreground + "c0";
  fg_faded = colors.swatch.foreground + "80";
  primary = colors.swatch.accent + "80";
  warning = colors.swatch.warning;
  error = colors.swatch.alert;
in
pkgs.writeScript "lock-script"
  ''
    #!${pkgs.fish}/bin/fish

    if pgrep -x swaylock > /dev/null
        echo "swaylock is already running"
        exit
    end

    # parse args
    argparse "n/no-fork" -- $argv

    set fork_arg ""
    if set -q $_flag_no_fork
        echo "swaylock won't fork"
    else
        set fork_arg '-f'
    end

    ${pkgs.pipewire}/bin/pw-play "${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/Lock.oga" &

    set --local transparent "00000000"
    set --local image_args ""
    set --local images

    # take screenshot of each output and blur it
    for output in (${pkgs.sway}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.active == true) | .name')
        set --local image_file "$HOME/.lock-$output.jpg"
        ${pkgs.grim}/bin/grim -o $output $image_file
        ${pkgs.imagemagick}/bin/convert "$image_file" -resize 5% -fill "#${bg}" -colorize 25% -blur 15x1 -resize 2000% "$image_file"
        # TODO: use `composite` to overlay a lock icon
        set image_args $image_args "--image" "$output:$image_file"
        set images $images $image_file
    end

    ${pkgs.swaylock}/bin/swaylock $fork_arg \
        $image_args \
    \
        --ignore-empty-password \
        --scaling=fill \
        --disable-caps-lock-text \
        --indicator-caps-lock \
        --color 000000 \
    \
        --ring-color=$transparent \
        --ring-wrong-color=${error} \
        --ring-ver-color=$transparent \
        --ring-caps-lock-color=$transparent \
        --ring-clear-color=${warning} \
    \
        --indicator-radius 128 \
        --indicator-thickness 4 \
    \
        --inside-color=$transparent \
        --inside-ver-color=$transparent \
        --inside-wrong-color=$transparent \
        --inside-clear-color=$transparent \
        --inside-caps-lock-color=$transparent \
    \
        --key-hl-color=${fg_faded} \
        --bs-hl-color=${primary} \
        --caps-lock-key-hl-color=${warning} \
        --caps-lock-bs-hl-color=${primary} \
        --separator-color=$transparent \
        -n \
    \
        --text-color=${fg} \
        --text-ver-color=$transparent \
        --text-clear-color=$transparent \
        --text-wrong-color=$transparent \
        --text-caps-lock-color=${warning} \
    \
        --font "sans Thin" \
        --font-size 12 \

    rm $images
  ''
