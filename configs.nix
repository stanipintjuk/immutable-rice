{ pkgs, ... }:
{
  urxvt = 
    pkgs.writeScript
      "svarog-urxvt"
      "${pkgs.coreutils}/bin/env XENVIRONMENT=${pkgs.copyPathToStore ./dotfiles/urxvt-xresources} ${pkgs.rxvt_unicode}/bin/urxvt $@";

  rofi = "${pkgs.rofi}/bin/rofi -show run";

  conky =
    pkgs.writeScript 
      "svarog-conky" 
      "${pkgs.conky}/bin/conky -c ${pkgs.copyPathToStore ./dotfiles/conky.conf}";
}
