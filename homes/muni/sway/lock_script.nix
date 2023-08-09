{
  config,
  pkgs,
  ...
}: let
  bg = config.muse.theme.finalPalette.background;
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

    set --local image_args
    set --local images

    # take screenshot of each output and blur it
    for output in (${pkgs.sway}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.active == true) | .name')
        set --local image_file "$HOME/.lock-$output.jpg"
        ${pkgs.grim}/bin/grim -o $output $image_file
        ${pkgs.imagemagick}/bin/convert "$image_file" -resize 5% -fill "#${bg}" -colorize 25% -blur 15x1 -resize 2000% "$image_file"
        # TODO: use `composite` to overlay a lock icon
        set image_args $image_args "-i" "$output:$image_file"
        set images $images $image_file
    end

    ${pkgs.swaylock}/bin/swaylock $fork_arg $image_args

    rm $images
  ''
