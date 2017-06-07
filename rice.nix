{ pkgs, config, ... }:
let 
  # Change this variable to a configurations file with your prefered i3 keymaps.
  # That file must only contain your keymaps and nothing else.
  i3-keys = 
    builtins.readFile /home/stani/.config/i3/i3config_keys;

  urxvt = import ./urxvt.nix { inherit pkgs; }; 
  rofi = import ./rofi.nix { inherit pkgs; };
  conky = import ./conky.nix { inherit pkgs; };
  wallpaper = pkgs.copyPathToStore ./art/the-technomancer.png;

  i3-config = 
    import ./i3config/i3config.nix {
      keymaps = i3-keys;
      terminal = urxvt;
      launcher = rofi;
      inherit pkgs conky config wallpaper;
    };

  i3-config-file =
    pkgs.writeTextFile {
      name = "technomancer-i3.conf";
      text = i3-config;
    };
in
{
  # Booting eyecandy
  #boot.loader.grub.splashImage = ./art/grub.png;
  #boot.loader.grub.gfxmodeEfi = "1920x1080";

  #boot.kernelParams = [ "quiet" "vga=current" "vt.global_cursor_default=0" ];

  #boot.plymouth.enable = true;
  #boot.plymouth.logo = ./art/boot.png;
  #boot.plymouth.theme = "fade-in";
  
  fonts.fonts = [pkgs.ubuntu_font_family];
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
        background = wallpaper;
      };

      # Setup i3
      windowManager.i3 = {
        enable = true;
        configFile = i3-config-file;
      };
    };
  };

  #TODO: remove these
  services.xserver.displayManager.lightdm.autoLogin
    = if config.system.build ? vm 
      then { 
        user = "stani"; 
        enable = true;
      } 
      else 
        {};

  services.xserver.windowManager.default = "i3";
    
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
