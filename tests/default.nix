{
  pkgs,
  lib,
  canvas,
  home-manager,
  dmsModule,
  nixvimModule,
  commaModule,
}:
let
  runSuite =
    name: tests:
    let
      failures = lib.runTests tests;
      render =
        f:
        "FAIL ${f.name}\n  expected: ${builtins.toJSON f.expected}\n  got:      ${builtins.toJSON f.result}";
    in
    if failures == [ ] then
      pkgs.runCommand "palette-tests-${name}" { } "echo ok > $out"
    else
      pkgs.runCommand "palette-tests-${name}" { text = lib.concatMapStringsSep "\n" render failures; } ''
        echo "$text"
        exit 1
      '';
in
{
  catalog = runSuite "catalog" (import ./catalog.nix { inherit lib pkgs canvas; });
  themes = runSuite "themes" (import ./themes.nix { inherit lib; });
  home = runSuite "home" (
    import ./home.nix {
      inherit
        pkgs
        lib
        canvas
        home-manager
        ;
    }
  );
  smoke = runSuite "smoke" (
    import ./smoke.nix {
      inherit
        pkgs
        lib
        canvas
        home-manager
        dmsModule
        nixvimModule
        commaModule
        ;
    }
  );
}
