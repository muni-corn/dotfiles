{
  lib,
  stdenv,
  fetchurl,
  lv2,
  fftwFloat,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "talentedhack";
  version = "master";

  src = fetchurl {
    url = "https://github.com/jeremysalwen/TalentedHack/archive/refs/heads/master.tar.gz";
    sha256 = "1bkfi2wkrnsimc2nrqm3h3s7l9jzsn5r3lr17hskf8hk74bgn4yz";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    lv2
    fftwFloat
  ];

  # To avoid name clashes, plugins should be compiled with symbols hidden, except for `lv2_descriptor`:
  preConfigure = ''
    sed -r 's/^CFLAGS.*$/\0 -fvisibility=hidden/' -i Makefile
  '';

  installPhase = ''
    d=$out/lib/lv2/talentedhack.lv2
    mkdir -p $d
    cp *.so *.ttl $d
  '';

  meta = with lib; {
    homepage = "https://github.com/jeremysalwen/TalentedHack";
    description = "LV2 port of Autotalent pitch correction plugin";
    license = licenses.gpl3;
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux;
  };
}
