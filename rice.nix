{ pkgs, ... }:
let configs = import ./configs.nix pkgs; in
{
  # Booting eyecandy
  #boot.loader.grub.splashImage = ./art/grub.png;
  #boot.loader.grub.gfxmodeEfi = "1920x1080";

  boot.kernelParams = [ "quiet" "vga=current" "vt.global_cursor_default=0" ];

  boot.plymouth.enable = true;
  boot.plymouth.logo = ./art/boot.png;
  boot.plymouth.theme = "fade-in";
  
  # This doesnt work so I have to put the image into the store first and do the next thing
  #services.xserver.displayManager.lightdm.background = 
    #''${ ./art/leshy2.png } '';

  # Desktop environment
  services = {
    compton = {
      enable = true;
      fade = true;
    };

    xserver = {
  
      # Setting up the display manager
      displayManager.lightdm = {
        enable = true;
        background = pkgs.copyPathToStore ./art/leshy.png;
      };

      # Setup i3
      windowManager.i3 = {
        enable = true;
        configFile = pkgs.writeTextFile {
            name = "i3config";
            text = import ./dotfiles/i3config.nix {
              keymaps = builtins.readFile /home/stani/.config/i3/i3config_keys;
              terminal = configs.urxvt;
              launcher = configs.rofi;
              conky = configs.conky;
            };
        };
      };
    };
  };

# Gtk themes and iconpacks
  #services.xserver.displayManager.lightdm.greeters.gtk = {
  #  theme.name = "Numix";
  #  theme.package = pkgs.numix-gtk-theme;
  #  iconTheme.name = "Faba";
  #  iconTheme.package = pkgs.faba-icon-theme;
  #};

  #environment.systemPackages = with pkgs; [
  #  faba-icon-theme
  #  numix-gtk-theme
  #  numix-icon-theme-circle
  #  lxappearance
  #];
}
