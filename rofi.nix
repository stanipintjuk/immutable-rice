{ pkgs }:
let 
  colors = import ./colors.nix;
  i3colors = import ./i3config/colors.nix;
  urxvt = import ./urxvt.nix { inherit pkgs; };

  rofi-config = import ./dotfiles/rofi.config {
    colors = i3colors;
    terminal = urxvt;
  };

  rofi-config-file = pkgs.writeTextFile {
    name = "svorag-rofi.config";
    text = rofi-config;
  };

  roficmd = 
    ''
      ${pkgs.coreutils}/bin/env XENVIRONMENT=${rofi-config-file} ${pkgs.rofi}/bin/rofi -display-run λ -show run
    '';

in

  with colors;
    pkgs.writeScript "svarog-rofi" roficmd
