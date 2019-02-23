local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local xdg_menu = require("archmenu")
require("awful.autofocus")
require("menu")
awful.rules = require("awful.rules")

if awesome.startup_errors then
    naughty.notify({preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors})
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err})
        in_error = false
    end)
end

function run_or_raise(cmd, properties)
    local matcher = function (c)
        return awful.rules.match(c, properties)
    end
    awful.client.run_or_raise(cmd, matcher)
end

terminal = "sakura -c 89 -r 22"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
cmd = "Mod1"
ctl = "Control"
sht = "Shift"
opt = "Mod4"
theme = "newblue"
browser = "chromium"
browser_win = "Chromium"

beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/" .. theme .. "/theme.lua")
beautiful.systray_icon_spacing = 20

if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
naughty.config.padding = 25
naughty.config.spacing = 10
naughty.config.defaults = {
    timeout = 5,
    text = "",
    screen = 1,
    ontop = true,
    font = "Noto Sans 12",
    margin = "5",
    border_width = "1",
    position = "top_right",
    opacity = 0.9,
}

-- menu
local suspendmenu = {
    {"Suspend", "i3lock -e -t -i ~/lock.png; systemctl suspend"},
}

local awesomemenu = {
    {"manual", terminal .. " -e man awesome"},
    {"edit config", editor_cmd .. " " .. awesome.conffile},
    {"restart", awesome.restart },
    {"quit", awesome.quit }
}
local shortcutmenu = {
    {"Chromium", "chromium"},
    {"Twitter", "proxychains corebird"},
    {"Clementine", "clementine"},
    {"Chars", "gucharmap"},
    {"Steam", "steam"},
    {"Email", "claws-mail"},
    {"XP", "/usr/lib/virtualbox/VirtualBox --comment \"XP\" --startvm \"0b2a46ca-c48e-4706-bf7b-cef2c43ff445\""},
    {"Virtualbox", "virtualbox"},
    {"Deadbeef", "deadbeef"},
    {"qBittorrent", "qbittorrent -style GTK+"},
}
local mainmenu = awful.menu({
    items = {
        {"File", "thunar"},
        {"Firefox", "/usr/bin/firefox"},
        {"Terminal", "sakura -c 89 -r 22"},
        {"Shortcuts", shortcutmenu, beautiful.awesome_icon},
        {"AllApps", xdgmenu, beautiful.awesome_icon},
        {"Awesome", awesomemenu, beautiful.awesome_icon},
        {"Suspend", suspendmenu, beautiful.awesome_icon},
        {"Next", "feh --randomize --bg-fill ~/.wallpaper/*"},
        {"Lock", "/usr/bin/bash -c 'i3lock -e -t -i ~/lock.png'"},
        {"Exit", "oblogout"},
    }
})

-- menubar configuration
menubar.utils.terminal = sakura -- Set the ter<p></p>minal for applications that require it

-- config wibox
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)
timeicon = wibox.widget.imagebox()
timeicon:set_image(beautiful.widget_clock)
sysicon = wibox.widget.imagebox()
sysicon:set_image(beautiful.widget_sysload)
weathericon = wibox.widget.imagebox()
weathericon:set_image(beautiful.widget_temp)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)
netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)

-- split widget
splitl = wibox.widget.textbox()
splitl:set_markup("<span color=\"#FFD200\">" .. " | " .. "</span>")
splitr = wibox.widget.textbox()
splitr:set_markup("<span color=\"#FFD200\">" .. " | " .. "</span>")

-- volume widget
volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume, "<span color=\"#ADFF00\" font=\"Noto Sans Bold 10\">🔊 $1%</span>", 3, "Master")
volwidget:buttons(
    awful.util.table.join(
        awful.button({ }, 1, function ()
            awful.util.spawn("amixer -q sset Master toggle")
        end),
        awful.button({ }, 3, function ()
            awful.util.spawn(terminal .. " -e alsamixer")
        end),
        awful.button({ }, 4, function ()
            awful.util.spawn("amixer -q sset Master 2%+,2%+")
        end),
        awful.button({ }, 5, function ()
            awful.util.spawn("amixer -q sset Master 2%-,2%-")
        end)
    )
)

-- deadbeef widget
--deadbeef = wibox.widget.textbox()
--deadbeef:set_align("right")
--function deadbeef_s(widget)
    --local status = io.popen('deadbeef --nowplaying "%a - %t"'):read("*all")
    ----deadbeef:set_markup("<span color=\"" .. color .. "\">" .. status .. "</span>")
    --deadbeef:set_text(status)
--end
--deadbeef_s(deadbeef)
--timer_deadbeef = timer({timeout = 3})
--timer_deadbeef:connect_signal("timeout", function () deadbeef_s(deadbeef) end)
--timer_deadbeef:start()

-- network widget
--function get_net()
    --local fd = io.popen("~/.config/awesome/utils.sh netinfo")
    --local str = fd:read("*all")
    --fd:close()
    --return str
--end
netinfo = wibox.widget.textbox()
netinfo.align = "right"
netinfo.forced_width = 115
vicious.register(netinfo, vicious.widgets.net, "<span color=\"#00FFF2\" font=\"Noto Sans Bold 10\">⬇ ${eno1 down_kb}/${eno1 up_kb} ⬆</span>", 1)

-- sysinfo widget
--function get_sysinfo()
    --local fd = io.popen("~/.config/awesome/utils.sh sysinfo")
    --local str = fd:read("*all")
    --fd:close()
    --return str
--end
sysload = wibox.widget.textbox()
vicious.register(sysload, vicious.widgets.uptime, "<span color=\"#F92672\" font=\"Noto Sans Bold 10\">$4 $5 $6</span>", 5)

-- textclock widget
function get_time()
    local fd = io.popen("~/.config/awesome/utils.sh time")
    local str = fd:read("*all")
    fd:close()
    return str
end
mytextclock = awful.widget.textclock("<span font=\"Noto Sans Bold 10\" color=\"#00FF16\">%b-%d / %a %I:%M:%S %p</span>", 1)
mytextclock_t = awful.tooltip({objects = {mytextclock}})
mytextclock_t:set_text(get_time())
mytextclock:buttons(
    awful.util.table.join(
        awful.button({ }, 3, function () awful.util.spawn("zenity --calendar") end)
    )
)

-- battery widget
-- battery indicator, using smapi
local battery_state = {
    Unknown = '<span color="yellow">? ',
    Full = '<span color="#ffffff">↯',
    Charging = '<span color="#00FF16">+ ',
    Discharging = '<span color="#1e90ff">– ',
}
function update_batwidget()
    local bat_dir = '/sys/class/power_supply/BAT0/'
    local f = io.open(bat_dir .. 'status')
    if not f then
        batterywidget:set_markup('<span color="red">ERR</span>')
        return
    end
    local state = f:read('*l')
    f:close()
    local state_text = battery_state[state] or battery_state.unknown
    f = io.open(bat_dir .. 'capacity')
    if not f then
        batterywidget:set_markup('<span color="red">ERR</span>')
        return
    end
    local percent = tonumber(f:read('*l'))
    f:close()
    if  percent <= 30 and percent > 10 and state == 'Discharging' then
        naughty.notify({title = "Battery Warning",
            text = "Battery low! " .. percent .."%" .. " left!",
            fg = "#ffffff",
            bg = "#C91C1C",
            timeout = 15,
            position = "bottom_right"
        })
    elseif percent <= 10 and state == 'Discharging' then
        awful.util.spawn("systemctl suspend")
        percent = '<span color="red">' .. percent .. '</span>'
    end
    batterywidget:set_markup(state_text .. percent .. '%</span>' .. '<span color="#FFD200">' .. ' | ' .. '</span>')
end
batterywidget = wibox.widget.textbox('↯??%')
update_batwidget()
timer_battery = timer({timeout = 30})
timer_battery:connect_signal("timeout", update_batwidget)
timer_battery:start()
batterywidget:buttons(
    awful.util.table.join(
        awful.button({ }, 1, function ()
            awful.util.spawn_with_shell("feh --randomize --bg-fill ~/.wallpaper/*")
        end),
        awful.button({ }, 3, function ()
            awful.util.spawn_with_shell("sh ~/git/dotfiles/scripts/shutdown_dialog.sh")
        end)
    )
)

---- weather widget
--function get_weather()
    --local fd = io.popen("~/.config/awesome/utils.sh tooltip_temp")
    --local str = fd:read("*all")
    --fd:close()
    --return str
--end
--tempwidget = wibox.widget.textbox()
--tempwidget:set_align("right")
--function get_weather_statusbar(widget)
     --local status = io.popen("~/.config/awesome/utils.sh display_temp_only"):read("*all")
     --local color = "#FFC100"
     --tempwidget:set_markup("<span font=\"Noto Sans Bold 10\" color=\"" .. color .. "\">" .. status .. "</span>")
--end
--get_weather_statusbar(tempwidget)
--weather_t = awful.tooltip({objects = {tempwidget}})
--weather_t:set_text(get_weather())

-- mpd widget
--mpdicon = widget({type = "imagebox" })
--mpdicon.image = image(beautiful.widget_mpd)
-- display
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd, function (widget, args)
    if args["{state}"] == "Stop" then
      return " - "
    else
      return ' ' .. args["{Artist}"]..' - '.. args["{Title}"] .. ' '
    end
end, 3)
mpdwidget:buttons(
    awful.util.table.join(
        awful.button({ }, 1, function ()
            awful.util.spawn("mpc next")
        end),
        awful.button({ }, 3, function ()
            awful.util.spawn("sakura -c 95 -r 33 -e ncmpcpp")
        end)
    )
)

-- cpu widget
--cpuwidget = awful.widget.graph()
--cpuwidget:set_width(50)
--cpuwidget:set_background_color("#494B4F")
--cpuwidget:set_color({type = "linear", from = {0, 0}, to = {10,0}, stops = {{0, "#FF5656"}, {0.5, "#88A175"},
                    --{1, "#AECF96"}}})
--vicious.register(cpuwidget, vicious.widgets.cpu, "$1")

-- update scripts
timer_update = timer({timeout = 120})
timer_update:connect_signal("timeout", function ()
    --weather_t:set_text(get_weather())
    mytextclock_t:set_text(get_time())
    --get_weather_statusbar(tempwidget)
end)
timer_update:start()

timer_wallpaper = timer({timeout = 600})
timer_wallpaper:connect_signal("timeout", function ()
    awful.util.spawn_with_shell("~/.config/awesome/utils.sh update")
end)
awful.util.spawn_with_shell("feh --randomize --bg-fill ~/.wallpaper/*")
timer_wallpaper:start()

--mpdwidget = wibox.widget.background(mpdwidget, "#B89B4F")
--[[
netinfo = wibox.widget.background(netinfo, "#C0EE57")
sysload = wibox.widget.background(sysload, "#11FB0E")
volwidget = wibox.widget.background(volwidget, "#1B98C4")
mytextclock = wibox.widget.background(mytextclock, "#281833")
batterywidget = wibox.widget.background(batterywidget, "#D42F69")
]]

-- tags
local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

tags = {
    names = {" 一 ", " 二 ", " 三 ", " 四 ", " 五 "},
    layout = {layouts[1], layouts[4], layouts[3], layouts[1], layouts[1]}
}

for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end

-- create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ cmd }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ cmd }, 3, awful.client.toggletag),
    awful.button({ }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c.minimized = false
            if not c:isvisible() then
                awful.tag.viewonly(c:tags()[1])
            end
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical = not c.maximized_vertical
    end),
    awful.button({ }, 3, function () mainmenu:toggle() end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 8, function (c) c.ontop = not c.ontop end),
    awful.button({ }, 9, function (c) c:kill() end))

for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt()
    -- create an imagebox widget which will contains an icon indicating which layout we're using.
    -- we need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, 1) end)))
    -- create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- create the wibox
    mywibox[s] = awful.wibox({position = "top",
        screen = s,
        height = 20})

    -- widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(splitl)
    left_layout:add(mypromptbox[s])

    -- widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(splitr)
    right_layout:add(mpdwidget)
    --right_layout:add(netdownicon)
    --right_layout:add(deadbeef)
    right_layout:add(splitr)
    --right_layout:add(cpuwidget)
    right_layout:add(netinfo)
    right_layout:add(splitr)
    --right_layout:add(netupicon)
    --right_layout:add(tempwidget)
    --right_layout:add(splitr)
    --right_layout:add(sysicon)
    right_layout:add(sysload)
    right_layout:add(splitr)
    --right_layout:add(volicon)
    right_layout:add(volwidget)
    right_layout:add(splitr)
    if s == 1 then
        local systray = wibox.widget.systray()
        right_layout:add(systray)
    end
    right_layout:add(splitr)
    --right_layout:add(timeicon)
    right_layout:add(mytextclock)
    right_layout:add(splitr)
    --right_layout:add(baticon)
    right_layout:add(batterywidget)
    right_layout:add(splitr)
    right_layout:add(mylayoutbox[s])
    --right_layout:add(searchicon)
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)
end

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ cmd }, 1, awful.mouse.client.move),
    awful.button({ cmd }, 3, awful.mouse.client.resize)
)

globalkeys = awful.util.table.join(
    awful.key({ ctl }, "Left", awful.tag.viewprev),
    awful.key({ ctl }, "Right", awful.tag.viewnext),
    awful.key({ cmd }, "Escape", awful.tag.history.restore),
    awful.key({ cmd }, "j", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ cmd }, "k", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ opt }, "Tab", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ opt, sht }, "Tab", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ cmd }, "w", function () mainmenu:show() end),
    awful.key({ cmd, sht }, "j", function () awful.client.swap.byidx(1) end),
    awful.key({ cmd, sht }, "k", function () awful.client.swap.byidx(-1) end),
    awful.key({ cmd, ctl }, "j", function () awful.screen.focus_relative(1) end),
    awful.key({ cmd, ctl }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ cmd }, "Tab", function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

    awful.key({ cmd, ctl }, "e", function () run_or_raise("sakura -c 89 -r 22", {name = "sakura"}) end ),
    awful.key({ cmd, ctl }, "s", function () run_or_raise(browser, {class = browser_win}) end),
    awful.key({ cmd, ctl }, "w", function () run_or_raise("typora", {class = "Typora"}) end),
    awful.key({ cmd, ctl, opt }, "r", awesome.restart),
    awful.key({ cmd }, "#82", function () awful.util.spawn("amixer -q sset Master 2%-", false) end),
    awful.key({ cmd }, "#86", function () awful.util.spawn("amixer -q sset Master 2%+", false) end),
    awful.key({ cmd }, "r", function () awful.util.spawn_with_shell("bash -c '~/.config/awesome/utils.sh dmenu_start'", true) end),
    awful.key({ cmd, sht }, "q", function() awful.util.spawn_with_shell("zenity --question&&echo 'awesome.quit()' | awesome-client", false) end),
    awful.key({ cmd, ctl }, "d", function () run_or_raise("subl3", {name = "Sublime Text"}) end),
    awful.key({ cmd, sht }, "3", function () awful.util.spawn_with_shell('flameshot full -c', false) end),
    awful.key({ cmd, sht }, "4", false, function () awful.util.spawn_with_shell('flameshot gui', false) end),
    awful.key({ ctl }, "m", false, function () awful.util.spawn("bash -c '~/.config/awesome/utils.sh nowplaying'", false) end),
    awful.key({ opt }, "`", false, function () awful.util.spawn("bash -c '~/.config/awesome/utils.sh input_m'",false) end),
    awful.key({ cmd }, "#87", function () awful.util.spawn("xbacklight -dec 10", false) end),
    awful.key({ cmd }, "#89", function () awful.util.spawn("xbacklight -inc 10", false) end),
    awful.key({ cmd }, "#88", function () awful.util.spawn("xbacklight -set 50", false) end),
    awful.key({ ctl, cmd }, "l", function () awful.util.spawn("bash -c 'i3lock -e -f -i ~/lock.png'") end),
    awful.key({ opt, sht }, "e", function () awful.util.spawn("gnome-characters") end),
    awful.key({ cmd }, "t", function () awful.util.spawn("sakura -c 89 -r 22") end),
    awful.key({ cmd }, "e", function () awful.util.spawn("thunar") end),
    awful.key({ cmd }, "q", function () awful.util.spawn("xkill", false) end),
    awful.key({ opt, ctl }, "Right", function () awful.util.spawn_with_shell("mpc next") end),
    awful.key({ opt, ctl }, "Left", function () awful.util.spawn_with_shell("mpc prev") end),
    awful.key({ opt, ctl }, "Up", function () awful.util.spawn_with_shell("mpc volume +5") end),
    awful.key({ opt, ctl }, "Down", function () awful.util.spawn_with_shell("mpc volume -5") end),
    awful.key({ opt, ctl }, "l", function () awful.util.spawn_with_shell("mpc toggle") end),
    awful.key({ opt, ctl }, "k", function () awful.util.spawn_with_shell("mpc status") end),
    awful.key({ sht }, "space", function () awful.util.spawn_with_shell("albert toggle") end),
    awful.key({ cmd, ctl }, "h", function () awful.util.spawn_with_shell("copyq toggle") end),
    awful.key({ opt, sht }, "d", function () awful.util.spawn("xfce4-appfinder") end),
    awful.key({ cmd }, "l", function () awful.tag.incmwfact(0.05) end),
    awful.key({ cmd }, "h", function () awful.tag.incmwfact(-0.05) end),
    awful.key({ cmd, sht }, "h", function () awful.tag.incnmaster(1) end),
    awful.key({ cmd, sht }, "l", function () awful.tag.incnmaster(-1) end),
    awful.key({ cmd, ctl }, "h", function () awful.tag.incncol(1) end),
    awful.key({ cmd, ctl }, "l", function () awful.tag.incncol(-1) end),
    awful.key({ cmd }, "space", function () awful.layout.inc(layouts, 1) end),
    awful.key({ cmd, sht }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ cmd }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ cmd }, "u", awful.titlebar.toggle),
    awful.key({ opt }, "c", function (c) c:kill() end),
    awful.key({ cmd, ctl }, "space", awful.client.floating.toggle),
    awful.key({ cmd, ctl }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ cmd }, "o", awful.client.movetoscreen),
    awful.key({ cmd }, "a", function (c) c.ontop = not c.ontop end),
    awful.key({ cmd }, "z", function (c) c.minimized = true end),
    awful.key({ opt }, "f", function (c)
        c.fullscreen = not c.fullscreen
        c.ontop = c.ontop
    end),
    awful.key({ opt }, "x", function (c)
        if c.maximized_horizontal == true then
            if c.maximized_vertical == false then
                c.maximized_vertical = not c.maximized_vertical
                c.border_width = "0"
            else
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical = not c.maximized_vertical
                c.border_width = beautiful.border_width
            end
        else
            if c.maximized_vertical == true then
                c.maximized_horizontal = not c.maximized_horizontal
                c.border_width = "0"
            else
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical = not c.maximized_vertical
                c.border_width = "0"
            end
        end
    end),
    awful.key({ cmd }, "s", function (c)
        c.sticky = not c.sticky
    end),
    awful.key({ cmd }, "d", function (c)
        c.maximized_vertical = not c.maximized_vertical
    end),
    awful.key({ cmd }, "b", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
    end),
    awful.key({ ctl, cmd }, "Left", function ()
        awful.client.moveresize(-10, 0, 0, 0)
    end),
    awful.key({ ctl, cmd }, "Right", function ()
        awful.client.moveresize(10, 0, 0, 0)
    end),
    awful.key({ ctl, cmd }, "Up", function ()
        awful.client.moveresize(0, -10, 0, 0)
    end),
    awful.key({ ctl, cmd }, "Down", function ()
        awful.client.moveresize(0, 10, 0, 0)
    end),
    awful.key({ opt }, "h", function ()
        awful.tag.incmwfact(-0.05)
    end),
    awful.key({ opt }, "j", function ()
        awful.client.incwfact(-0.05)
    end),
    awful.key({ opt }, "k", function ()
        awful.client.incwfact(0.05)
    end),
    awful.key({ opt }, "l", function ()
        awful.tag.incmwfact(0.05)
    end)
)

-- extend globalkeys
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ ctl }, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewonly(tag)
                tag:view_only()
            end
        end),
        awful.key({ sht, ctl, alt }, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
          end
        end),
        awful.key({ ctl, cmd }, "#" .. i + 9, function ()
          if client.focus then
              local tag = client.focus.screen.tags[i]
              if tag then
                  client.focus:move_to_tag(tag)
              end
          end
        end),
        awful.key({ cmd, ctl, sht }, "#" .. i + 9, function ()
          if client.focus then
              local tag = client.focus.screen.tags[i]
              if tag then
                  client.focus:toggle_tag(tag)
              end
          end
        end)
    )
end

root.keys(globalkeys)

-- config signals
client.connect_signal("manage", function (c, startup)
    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:add(awful.titlebar.widget.stickybutton(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
            awful.button({ }, 1, function()
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end)
            )
        )

        -- now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)
        awful.titlebar(c):set_widget(layout)
    end
    -- honor size hints: if you want to drop the gaps between windows, set this to false.
    c.size_hints_honor = false
    -- floating clients don't overlap, cover
    -- the titlebar or get placed offscreen
    awful.placement.no_overlap(c)
    awful.placement.no_offscreen(c)

    -- enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)
    if not startup then
        -- set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)
        awful.titlebar.hide(c)

        if c.type == "normal" then
            if not c.size_hints.user_position or not c.size_hints.program_position then
                awful.placement.no_overlap(c)
                awful.placement.under_mouse(c)
                awful.placement.no_offscreen(c)
                awful.titlebar.hide(c)
            end
        elseif c.type ~= "normal" then
            awful.placement.centered(c,p)
            awful.titlebar.hide(c)
        end
    else
        awful.titlebar.hide(c)
    end
end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- rules
awful.rules.rules = {
    {rule = { },
        properties = {border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            keys = clientkeys,
            floating = true,
            size_hints_honor = false,
            buttons = clientbuttons
        },
    },
    {rule = {class = browser}, properties = {floating = true, tag = tags[1][1]}},
    {rule = {class = "Sakura"}, properties = {floating = false}},
    {rule = {class = "Steam"},  properties = {floating = true, tag = tags[1][5]}},
    {rule = {class = "Thunderbird"}, properties = {tag = tags[1][3]}},
    {rule = {class = "Typora"},
        properties = {floating = false, tag = tags[1][2]},
            maximized_vertical = true,
            maximized_horizontal = true
    },
    {rule = {name = "WeeChat"},
        properties = {floating = true, tag = tags[1][5]},
            maximized_vertical = true,
            maximized_horizontal = true
    },
}

-- autostart
awful.util.spawn_with_shell("fcitx -r")
--awful.util.spawn_with_shell("numlockx on")
awful.util.spawn_with_shell("xbacklight -set 40")
awful.util.spawn_with_shell("setxkbmap -layout us -option ctrl:nocaps")
awful.util.spawn_with_shell("xautolock -time 5 -locker 'i3lock -e -t -i ~/lock.png'")
awful.util.spawn_with_shell("feh --randomize --bg-fill ~/.wallpaper/*")
awful.util.spawn_with_shell("[ -z `pgrep compton` ]&&compton")
awful.util.spawn_with_shell("[ -z `pgrep zim` ]&&zim")
--awful.util.spawn_with_shell("[ -z `pgrep steam` ]&&steam")
awful.util.spawn_with_shell("[ -z `pgrep albert` ]&&albert")
awful.util.spawn_with_shell("[ -z `pgrep copyq` ]&&copyq")
awful.util.spawn_with_shell("[ -z `pgrep polkit-` ]&&/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
awful.util.spawn_with_shell("[ -z `pgrep pasystray` ]&&pasystray")
--awful.util.spawn_with_shell("[ -z `pgrep pnmixer` ]&&pnmixer")
--naughty.notify({title="Welcome", text=""})
