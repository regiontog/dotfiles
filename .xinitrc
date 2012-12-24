CONF=$XDG_CONFIG_HOME/X11

### X11 configuration
xmodmap $CONF/xmodmap
xbindkeys -f $CONF/xbindkeys
xrdb $CONF/Xresources

### Configure mouse
unclutter &
xsetroot -cursor_name left_ptr

# Background
feh --bg-fill ~/media/pics/wallpapers/*

## Pipeline conky to wmfs2
#for f in ~/.config/wmfs/scripts/*; do
#  conky -c $f | while true; read line; do wmfs -c status "$(basename $f) $line"; done &
#  done

### Start wm/de
exec xmonad
