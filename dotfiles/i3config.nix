{ keymaps, terminal, launcher, conky }:
''
set $term ${terminal}
set $launcher ${launcher}

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

font pango:monospace 8

bar {
  position top
	status_command i3status
}

for_window [class="URxvt"] border pixel 5
for_window [class="Firefox"] border pixel 5

exec --no-startup-id ~/.fehbg
exec --no-startup-id ${conky}

exec --no-startup-id urxvt

${keymaps}

''
