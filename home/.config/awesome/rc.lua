-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

require("vicious")
require("revelation")

-- Load Debian menu entries
require("debian.menu")

--runonce = require("runonce")
local keydoc = require("keydoc")

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
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")

beautiful.border_width = "1"
beautiful.border_normal = "#6F6F6F"
--beautiful.border_focus = "#8FAF9F" -- green
beautiful.border_focus = "#F18C96" -- orange

--for keydoc
beautiful.fg_widget_value = "#AECF96"
beautiful.fg_widget_value_important = "#FF0000"
beautiful.fg_widget_clock = "#FF5656"

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
--terminal = "gnome-terminal --disable-factory"
editor = os.getenv("EDITOR") or "editor"
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
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
  config = {
    {
        names = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
        layouts = { layouts[4], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2] }
    },
    { 
        names = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
        layouts = { layouts[2], layouts[4], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[3] }
    },
    { 
        names = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
        layouts = { layouts[2], layouts[4], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[3] }
    }
  }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.config[s].names, s, tags.config[s].layouts)
end

awful.tag.setproperty(tags[1][1], "mwfact", 0.75)
awful.tag.setproperty(tags[2][2], "mwfact", 0.75)
--awful.tag.seticon("/usr/share/pixmaps/firefox.png", tags[1][1])
--awful.tag.setproperty(tags[1][1], "icon_only", 1)
--awful.tag.seticon("/home/peterss/.local/share/icons/windows-logo.png", tags[2][1])
--awful.tag.seticon("/usr/share/app-install/icons/pidgin.png", tags[2][9])

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- {{{ Reusable separator
separator = widget({ type = "textbox" })
separator.text = "  "
-- }}}

--Create a weather widget

metarid = "eddv"
weatherwidget = widget({ type = "textbox" })
weatherwidget.text = awful.util.pread(
  "weather " .. metarid .. " --headers=Temperature --quiet -m | awk '{print $2, $3}'"
) -- replace METARID with the metar ID for your area. This uses metric. If you prefer Fahrenheit remove the "-m" in "--quiet -m".
weathertimer = timer(
  { timeout = 900 } -- Update every 15 minutes.
)
weathertimer:add_signal(
  "timeout", function()
     weatherwidget.text = awful.util.pread(
     "weather " .. metarid .. " --headers=Temperature --quiet -m | awk '{print $2, $3}' &"
   ) --replace METARID and remove -m if you want Fahrenheit
 end)

weathertimer:start() -- Start the timer
weatherwidget:add_signal(
"mouse::enter", function()
  weather = naughty.notify(
    {title="Weather",text=awful.util.pread("weather " .. metarid .. " -m")})
  end) -- this creates the hover feature. replace METARID and remove -m if you want Fahrenheit
weatherwidget:add_signal(
  "mouse::leave", function()
    naughty.destroy(weather)
  end)

-- Create a wibox for each screen and add it
mywibox = {}
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

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s], separator,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s], separator,
        weatherwidget, separator,
        s == 1 and mysystray or nil,
        separator, mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

mystatusbar = awful.wibox({ position = "bottom", screen = 1, ontop = false, width = 1, height = 16 })

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
    awful.key({ modkey,           }, "e", revelation),

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
    keydoc.group("Layout manipulation"),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end, "focus next screen"),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end, "focus previous screen"),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto, "jump to urgent client"),
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

    awful.key({ modkey, "Control" }, "n", awful.client.restore, "foobar"),

    awful.key({ modkey,           }, "F1", keydoc.display, "Display this help"),
    awful.key({ modkey,           }, "-", function () awful.layout.arrange(mouse.screen) end),
    
    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey,           }, "s",
              function ()
                  awful.prompt.run({ prompt = "ssh: " },
                  mypromptbox[mouse.screen].widget,
                  function(h) awful.util.spawn(terminal .. ' -e "ssh ' .. h .. '"') end,
                  function(cmd, cur_pos, ncomp)
                      -- get hosts and hostnames
                      local hosts = {}
                      f = io.popen("sed 's/#.*//;/[ \\t]*Host\\(Name\\)\\?[ \\t]\\+/!d;s///;/[*?]/d' " .. os.getenv("HOME") .. "/.ssh/config | sort")
                      for host in f:lines() do
                          table.insert(hosts, host)
                      end
                      f:close()
                      -- abort completion under certain circumstances
                      if cur_pos ~= #cmd + 1 and cmd:sub(cur_pos, cur_pos) ~= " " then
                          return cmd, cur_pos
                      end
                      -- match
                      local matches = {}
                      table.foreach(hosts, function(x)
                          if hosts[x]:find("^" .. cmd:sub(1, cur_pos):gsub('[-]', '[-]')) then
                              table.insert(matches, hosts[x])
                          end
                      end)
                      -- if there are no matches
                      if #matches == 0 then
                          return cmd, cur_pos
                      end
                      -- cycle
                      while ncomp > #matches do
                          ncomp = ncomp - #matches
                      end
                      -- return match and position
                      return matches[ncomp], #matches[ncomp] + 1
                  end,
                  awful.util.getdir("cache") .. "/ssh_history")
              end),
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
--    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, ".",      function (c) awful.client.incwfact(-0.05) end),
    awful.key({ modkey,           }, ",",      function (c) awful.client.incwfact( 0.05) end),
    awful.key({ modkey,           }, "t",
        function (c)
            local fhostname = io.popen("hostname")
            local local_hostname = fhostname:read("*line")
            fhostname:close()
            
            if string.find(c.name, "^mc ") ~= nil then -- midnight commander
              _, _, user, hostname, dir = string.find(c.name, "^mc %[(%w+)@(%w+)%]:(.+)$")
            elseif string.find(c.name, "^%d+:%d+:%d+ ") ~= nil then -- liquidprompt with time
              naughty.notify({text = "foobar"})
              if string.find(c.name, "@") then
                  _, _, user, hostname, dir = string.find(c.name, "^%d+:%d+:%d+ %[(%w+)@(%w+):(.+)%]")
              else
                  _, _, user, dir = string.find(c.name, "^%d+:%d+:%d+ %[(%w+):(.+)%]")
                  hostname = local_hostname
              end
            else -- normal shell
              _, _, user, hostname, dir = string.find(c.name, "^(%w+)@(%w+): (.+)$")
            end

            local local_user = os.getenv("USER")
            local home = os.getenv("HOME")
            local cmd
            naughty.notify({text = hostname})
            naughty.notify({text = user})

            if hostname ~= local_hostname then
                naughty.notify({text = "foreign hosts not (yet) supported"})
                return
            elseif user ~= local_user then
                local sudo_prompt = "[sudo] password for %p to access %U@%h:" .. dir .. ": "
                local sudo_cmd = "sh -c 'cd " .. dir .. "; bash'"
                cmd = string.format("%s -e \"sudo -u %s -p '%s' -s -- %s\"", terminal, user, sudo_prompt, sudo_cmd)
            else
                dir = dir:gsub("^~", home)
                cmd = terminal .. " --working-directory " .. dir
            end

            naughty.notify({text = cmd})
            awful.util.spawn(cmd)
        end),
    awful.key({ modkey,           }, "Menu", 
        function (c)
            if   c.titlebar then awful.titlebar.remove(c)
            else awful.titlebar.add(c, { modkey = modkey }) 
            end
        end),
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
                     maximized_vertical   = false,
                     maximized_horizontal = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "VirtualBox" },
      properties = { tag = tags[2][1] } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[2][9] } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
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
        awful.client.setslave(c)

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

autostart = {
    "conky -b",
    "glipper",
    "redshift",
    "pidgin",
    "indicator-weather",
--    "virtualbox-windows",
    "firefox",
    "volti"
}

for i=1, #autostart do
--    runonce.run(autostart[i])
end
