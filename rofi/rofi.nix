{ pkgs, terminal}:
let 
  colors = import ../colors.nix;

  rofi-config = import ./rofi-conf.nix {
    inherit colors terminal;
  };

  rofi-config-file = pkgs.writeTextFile {
    name = "technomancer-rofi.config";
    text = rofi-config;
  };

  roficmd = 
    ''
      ${pkgs.coreutils}/bin/env XENVIRONMENT=${rofi-config-file} ${pkgs.rofi}/bin/rofi -display-run λ -show run
    '';

in
  pkgs.writeScript "svarog-rofi" roficmd
