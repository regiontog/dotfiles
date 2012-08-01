-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
local vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/alan/alan.theme")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "root", "www", "dev", "term", "media", "misc"}, s,
                            layouts[2], layouts[2], layouts[2],
                            layouts[2], layouts[2], layouts[2])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu

editors = {
   { "vim", terminal .. " -e vim" },
   { "vi", terminal .. " -e vi" },
   { "nano", terminal .. " -e nano" }}

media = {
   { "vlc", "vlc" },
   { "music", terminal .. " -e ncmpcpp" }}

power = {
   { "reboot", terminal .. " -e sudo reboot" },
   { "power off", terminal .. " -e sudo poweroff" }}

inet = {
   { "firefox", "firefox" }}

mymainmenu = awful.menu({ items = {{ "editors", editors },
                                   { "media", media     },
                                   { "internet", inet   },
                                   { "power", power     }}})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Calendar widget to attach to the textclock
require('calendar2')
calendar2.addCalendarToWidget(mytextclock)

-- Uptime
uptime = widget({ type = "textbox" })
vicious.register( uptime, vicious.widgets.uptime, "<span color='" .. beautiful.fg_focus .. "'>UPTIME</span> $1 day(s) and $2 hour(s)")

-- System uname
uname = widget({ type = "textbox" })
vicious.register( uname, vicious.widgets.os, "<span color='" .. beautiful.arch_blue .. "'>$2</span>")

-- Create a systray
mysystray = widget({ type = "systray" })

-- Gmail widget and tooltip
mygmail = widget({ type = "textbox" })
gmail_t = awful.tooltip({ objects = { mygmail },})
vicious.register(mygmail, vicious.widgets.gmail,
                function (widget, args)
                    gmail_t:set_text(args["{subject}"])
                    gmail_t:add_to_object(mygmail)
                    return args["{count}"]
                 end, 2)

mails = widget({type = "textbox" })
mails.text = "<span color='" .. beautiful.fg_focus .. "'>MAILS</span> "

-- Partitions
rootpartition = widget({ type = "textbox" })
vicious.register(rootpartition, vicious.widgets.fs, "<span color='" .. beautiful.fg_focus .. "'>ROOT</span> ${/ used_p}% used of ${/ size_gb}GB", 180)

homepartition = widget({ type = "textbox" })
vicious.register(homepartition, vicious.widgets.fs, "<span color='" .. beautiful.fg_focus .. "'>HOME</span> ${/home used_p}% used of ${/home size_gb}GB", 180)

-- Cpu usage
cpu = widget({ type = "textbox" })
vicious.register( cpu, vicious.widgets.cpu, "<span color='" .. beautiful.fg_focus .. "'>CPU</span> $1%", 3)

-- Sound volume
volumewidget = widget ({ type = "textbox" })
vicious.register( volumewidget, vicious.widgets.volume, "<span color='" .. beautiful.fg_focus .. "'>VOL</span> $1%", 1, "Master" )
volumewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.button({ }, 3, function () awful.util.spawn("urxvt -e alsamixer", true) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 1dB+ umute", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 1dB- umute", false) end)
))

-- Net Widget
netupinfo = widget({ type = "textbox" })
vicious.register(netupinfo, vicious.widgets.net, "<span color='" .. beautiful.fg_focus .. "'>UP</span> ${eth0 up_kb}", 1)

netdowninfo = widget({ type = "textbox" })
vicious.register(netdowninfo, vicious.widgets.net, "<span color='" .. beautiful.fg_focus .. "'>DOWN</span> ${eth0 down_kb}", 1)

-- Memory usage
memwidget = widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem, "<span color='" .. beautiful.fg_focus .. "'>RAM</span> $1% used of $3MB", 1)

-- Seperators
line = widget({type = "textbox" })
line.text = "<span color=\"#404040\">│</span>"

space = widget({ type = "textbox" })
space.text = " "

-- MPD Icon
mpdicon = widget({ type = "imagebox" })
mpdicon.image = image(beautiful.widget_mpd)

-- Initialize MPD Widget
mpdwidget = widget({ type = "textbox" })
vicious.register(mpdwidget, vicious.widgets.mpd,
  function (widget, args)
    if args["{state}"] == "Stop" then
      return " - "
    else
      return args["{Artist}"]..' - '.. args["{Title}"]
    end
  end, 10)


-- MPD controls
music_play = awful.widget.launcher({
  image = beautiful.widget_play,
  command = "ncmpcpp toggle && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
})

music_pause = awful.widget.launcher({
  image = beautiful.widget_pause,
  command = "ncmpcpp toggle && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
})
music_pause.visible = false

music_stop = awful.widget.launcher({
  image = beautiful.widget_stop,
  command = "ncmpcpp stop && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
})

music_prev = awful.widget.launcher({
  image = beautiful.widget_prev,
  command = "ncmpcpp prev && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
})

music_next = awful.widget.launcher({
  image = beautiful.widget_next,
  command = "ncmpcpp next && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
})

-- Create a wibox for each screen and add it
myupperwibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the upper wibox
    myupperwibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    myupperwibox[s].widgets = {
        {
            space, mytaglist[s],
            space, mypromptbox[s],
            line,
            space, mails, mygmail, space,
            line,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        space, uname, space,
        line,
        mytextclock,
        line,
        space, uptime, space,
        line,
        space, memwidget, space,
        line,
        space, rootpartition, space,
        line,
        space, homepartition, space,
        line,
        space, cpu, space,
        line,
        space, netupinfo, space,
        line,
        space, netdowninfo, space,
        line,
        layout = awful.widget.layout.horizontal.rightleft
    }

    -- Create the bottom wibox
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s })
    -- Add widgets to the wibox - order matters
    mybottomwibox[s].widgets = {
        {
          mpdicon,
          mpdwidget,
          space,
          music_prev,
          music_stop,
          music_pause,
          music_play,
          music_next,
          line,
          space, volumewidget, space,
          line,
          layout = awful.widget.layout.horizontal.leftright
        },
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "URxvt" },
      properties = { size_hints_honor = false } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
