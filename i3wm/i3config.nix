{ config-extra, terminal, rofi, conky, pkgs, config, wallpaper }:
let colors = import ../colors.nix; in
with colors;
''
set $workspace1 1
set $workspace2 2
set $workspace3 3
set $workspace4 4
set $workspace5 5
set $workspace6 6
set $workspace7 7
set $workspace8 8
set $workspace9 9
set $workspace10 10

font pango:Ubuntu 8

# class                 container-border    container-backgr  text          indicator   window-border
client.focused          ${mlight}           ${mlight}         ${dark}       ${accent}   ${mlight}
client.focused_inactive ${mdark}            ${mdark}          ${light}      ${accent}   ${mdark}
client.unfocused        ${dark}             ${mdark2}         ${mlight}     ${accent}   ${mdark2}
client.urgent           ${accent}           ${dark}           ${light}      ${dark}     ${accent}
client.placeholder      ${mdark}            ${mdark}          ${light}      ${accent}   ${mdark}

client.background       ${light}

bar {
  position top
	status_command i3status --config ${pkgs.writeTextFile {
    name = "i3status.conf";
    text = import ./i3status.nix { inherit colors; };
    }
  }
  separator_symbol " · "
  
  colors {
    background ${dark}
    statusline ${light}
    separator ${accent}

    #                   border    background  text
    focused_workspace  ${dark}    ${dark}   ${mlight}
    active_workspace   ${dark}    ${dark}   ${mlight}
    inactive_workspace ${dark}    ${dark}    ${mdark}
    urgent_workspace   ${accent}    ${dark} ${accent}
    binding_mode       ${dark}    ${dark}  ${accent}
  }
}

for_window [class="URxvt"] border pixel 5
for_window [class="vlc"] border pixel 5
for_window [class="Firefox"] border pixel 5

#TODO: remove these
${
  if config.system.build ? vm 
  then "exec --no-startup-id xrandr --output Virtual-1 --mode 1920x1080"
  else ""
} 

exec --no-startup-id ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}
exec --no-startup-id ${conky}

${import config-extra {inherit pkgs terminal rofi config wallpaper;}}

''
