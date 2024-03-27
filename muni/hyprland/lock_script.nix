{
  config,
  pkgs,
  ...
}: let
  bg = config.muse.theme.palette.background;
in
  pkgs.writeScript "lock-script"
  ''
    #!${pkgs.fish}/bin/fish

    if pgrep -x hyprlock > /dev/null
        echo "hyprlock is already running"
        exit
    end

    ${pkgs.pipewire}/bin/pw-play "${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/desktop-screen-lock.oga" &

    set --local images

    # take screenshot of each output
    for output in (hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | .name')
        set --local image_file "$HOME/.lock-$output.png"
        ${pkgs.grim}/bin/grim -o $output $image_file
        ${pkgs.imagemagick}/bin/convert "$image_file" -resize 5% -fill "#${bg}" -colorize 25% "$image_file"
        set images $images $image_file
    end

    hyprlock

    rm $images
  ''
