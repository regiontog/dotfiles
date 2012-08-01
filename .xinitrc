### X11 configuration
xmodmap ~/.xmodmap
xbindkeys -f ~/.xbindkeys
xrdb ~/.Xresources
xrandr --output DVI-0 --preferred --right-of DVI-1

unclutter &

### Background
#feh --bg-fill ~/Pictures/bg.*

## Pipeline conky to wmfs2
#for f in ~/.config/wmfs/scripts/*; do
#  name=$(echo $f | sed 's/\/home\/alan\/.config\/wmfs\/scripts\///')
#  conky -c $f | while true; read line; do wmfs -c status "$name $line"; done &
#  done

### Start wm/de
exec awesome
