{
  lib,
  runCommand,
  env,
}:
# `env` is the full uv2nix-built virtualenv for muni-scripts (built via
# devenv's languages.python.import), which also contains its Python
# interpreter and every dependency's console scripts (ttx, pdf2txt.py,
# etc). wrap it down to just the two scripts we actually want on $PATH.
runCommand "muni-scripts"
  {
    meta = {
      description = "muni's timesheet generation scripts";
      mainProgram = "timesheet";
    };
  }
  ''
    mkdir -p "$out/bin"
    ln -s ${lib.getExe' env "timesheet"} "$out/bin/timesheet"
    ln -s ${lib.getExe' env "new-timesheet"} "$out/bin/new-timesheet"
  ''
