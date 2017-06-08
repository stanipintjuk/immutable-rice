{ pkgs }:
let 
  i3colors = import ./i3config/colors.nix;
  
  urxvt-config = 
    import ./dotfiles/urxvt-xresources { colors = i3colors; };

  urxvt-config-file =
    pkgs.writeTextFile {
      name="urxvt-xresources"; 
      text=urxvt-config;
    };

in

  pkgs.writeScript
  "svarog-urxvt"
  ''${pkgs.coreutils}/bin/env XENVIRONMENT=${urxvt-config-file} ${pkgs.rxvt_unicode}/bin/urxvt $@''
