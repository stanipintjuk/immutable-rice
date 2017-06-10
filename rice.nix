{ pkgs, config, ... }:

# NOTE: Change the configuration.nix file to match your system
# ANOTHER NOTE: Conky configuration will not work if you don't have 8 cpus
with import ./configuration.nix;
let 
  # Change this variable to a configurations file with your prefered i3 keymaps.
  # That file must only contain your keymaps and nothing else.
  i3-keys = 
    builtins.readFile i3-keys-path;

  urxvt = import ./urxvt/urxvt.nix { inherit pkgs; }; 
  rofi = import ./rofi/rofi.nix { inherit pkgs; terminal = urxvt; };
  conky = import ./conky/conky.nix { inherit pkgs; };
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

  gtk2-theme = import ./paper-gtk2-theme.nix pkgs;
  
  isVm = config.system.build ? vm;
in
{

  imports = [ 
    gtk2-theme
  ];
  
  fonts.fonts = [
    pkgs.ubuntu_font_family
    pkgs.powerline-fonts
  ];

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
    = if isVm
      then { 
        user = username; 
        enable = true;
      } 
      else 
        {};

  services.xserver.windowManager.default = "i3";
}
