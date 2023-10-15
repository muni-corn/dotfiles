{
  config,
  pkgs,
}: let
  mixScript = pkgs.writeScript "mix" ''
    #!${config.programs.fish.package}/bin/fish
    function mix_hex_channel -a first second
        set hex_result (math --base hex "(0x$first + 0x$second) / 2")
        string sub -s 3 -l 2 $hex_result
    end

    set first_r (string sub -s 1 -l 2 $argv[1])
    set first_g (string sub -s 3 -l 2 $argv[1])
    set first_b (string sub -s 5 -l 2 $argv[1])

    set second_r (string sub -s 1 -l 2 $argv[2])
    set second_g (string sub -s 3 -l 2 $argv[2])
    set second_b (string sub -s 5 -l 2 $argv[2])

    set final_r (mix_hex_channel $first_r $second_r)
    set final_g (mix_hex_channel $first_g $second_g)
    set final_b (mix_hex_channel $first_b $second_b)

    echo -n "$final_r$final_g$final_b" > $out
  '';

  mix = first: second:
    builtins.readFile (pkgs.runCommandLocal
      "color-mix-${first}-${second}"
      {inherit first second;}
      "${mixScript} ${first} ${second}");
in {
  paletteFromBase16 = bases:
    with bases; {
      # shades
      black = base00;
      dark-gray = base01;
      gray = base02;
      light-gray = base03;
      silver = base04;
      light-silver = base05;
      white = base06;
      bright-white = base07;

      # normal colors
      red = base08;
      orange = base09;
      yellow = base0A;
      green = base0B;
      cyan = base0C;
      blue = base0D;
      purple = base0E;
      brown = base0F;

      # bright colors
      bright-red = mix base06 base08;
      bright-orange = mix base06 base09;
      bright-yellow = mix base06 base0A;
      bright-green = mix base06 base0B;
      bright-cyan = mix base06 base0C;
      bright-blue = mix base06 base0D;
      bright-purple = mix base06 base0E;
      bright-brown = mix base06 base0F;

      # other named colors
      background = base00;
      foreground = base06;
      accent = base0D;
      warning = base09;
      alert = base08;
    };
}
