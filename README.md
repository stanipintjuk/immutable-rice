#Immutable Rice

A configuration of i3, urxvt, conky and rofi using the NixOS configuration manager


## Usage
Clone the repo, change the values in `configuration.nix` to your own, import rice.nix into your configuration and then simply build and apply.

## Note
This particular conky configration displays 8 cores, so it won't work on systems that have less than that.
