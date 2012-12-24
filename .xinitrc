### X11 configuration
xmodmap ~/.xmodmap
xbindkeys -f ~/.xbindkeys
xrdb ~/.Xresources
xrandr --output DVI-0 --preferred --right-of DVI-1

### Configure mouse
unclutter &
xsetroot -cursor_name left_ptr

### Background
#feh --bg-fill ~/Pictures/bg.*

## Pipeline conky to wmfs2
#for f in ~/.config/wmfs/scripts/*; do
#  conky -c $f | while true; read line; do wmfs -c status "$(basename $f) $line"; done &
#  done

### Start wm/de
exec gnome-session-cinnamon
