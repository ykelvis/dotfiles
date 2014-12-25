-----------------------------------
--   "New Blue" awesome theme    --
--     By TheImmortalPhoenix     --
-- edited by Giulio B. (ewaves)  --
-----------------------------------



-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.confdir = os.getenv("HOME") .. "/.config/awesome/newblue"
-- theme.wallpaper = "/usr/share/awesome/themes/zenburn/zenburn-background.png"
-- wallpaper_cmd = { "nitrogen --restore" }
-- }}}

-- {{{ Styles
theme.font      = "Noto Sans 9"

--theme.menu_fg_normal = "#4A90D9"   --color txt pip
--theme.menu_fg_focus =  "#4A90D9"
--theme.menu_bg_normal = "#EDEDED"   --background menu
--theme.menu_bg_focus  = "#343434"
-- {{{ Colors
theme.fg_normal = "#FFFFFF"
--theme.fg_focus  = "#3ca4d8"
theme.fg_focus  = "#77BEE0"
theme.fg_urgent = "#927d9e"
theme.bg_normal = "#656565"
theme.bg_focus  = "#656565"
theme.bg_urgent = "#FF0000"
theme.bg_systray = "#656565"
-- }}}

-- {{{ Borders

theme.border_width  = 0
theme.border_normal = "#1793D1"
--theme.border_focus  = "#585417"
theme.border_focus  = "#C3C58C"
theme.border_marked = "#3cd860"

-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#333333"
theme.titlebar_bg_normal = "#333333"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}
theme.taglist_bg_focus = "#656565"
theme.taglist_bg_normal = "#656565"
theme.taglist_fg_normal = "#FFFFFF"
theme.taglist_fg_focus = "#0FE622"
theme.tasklist_bg_focus = "#656565"
theme.tasklist_bg_normal = "#656565"
theme.tasklist_fg_focus = "#0FE622"
theme.tasklist_fg_normal = "#FFFFFF"
theme.tooltip_border_width= 0   
theme.tooltip_fg_color= "#FFFFFF"   
theme.tooltip_bg_color= "#313131"   
theme.tooltip_border_color= "#00FF16"   
theme.tooltip_font= "Noto Sans 10"
theme.tooltip_opacity= 0.9

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#1A1A1A"
--theme.border_widget    = "#3F3F3F"
--beautiful.widget_logout = theme.confdir .. "Logout.png"
-- }}}

-- {{{ Mouse finder

theme.mouse_finder_color = "#6b8ba3"
-- mouse_finder_[timeout|animate_timeout|radius|factor]

-- }}}

-- {{{ Menu

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
-- theme.menu_border_width = "1"
-- theme.menu_border_color = "#afa72e"
theme.menu_height = "20"
theme.menu_width  = "120"
theme.menu_border_width  = "0"
theme.menu_fg_normal = "#FFFFFF"   --color txt pip
theme.menu_fg_focus =  "#343434"
theme.menu_bg_normal = "#272822"   --background menu
theme.menu_bg_focus  = "#177EE6"

-- }}}


-- {{{ Icons
theme.arr1 = theme.confdir .. "/widgets/arr1.png"
theme.arr2 = theme.confdir .. "/widgets/arr2.png"
theme.arr3 = theme.confdir .. "/widgets/arr3.png"
theme.arr4 = theme.confdir .. "/widgets/arr4.png"
theme.arr5 = theme.confdir .. "/widgets/arr5.png"
theme.arr6 = theme.confdir .. "/widgets/arr6.png"
theme.arr7 = theme.confdir .. "/widgets/arr7.png"
theme.arr8 = theme.confdir .. "/widgets/arr8.png"
theme.arr9 = theme.confdir .. "/widgets/arr9.png"


theme.arrl = theme.confdir .. "/widgets/arrl.png"
theme.arrl_dl  = theme.confdir .. "/widgets/arrl_dl.png"
theme.arrl_ld  = theme.confdir .. "/widgets/arrl_ld.png"
theme.arrl_ld_sf  = theme.confdir .. "/widgets/arrl_ld_sf.png"
theme.arrl_dl_sf  = theme.confdir .. "/widgets/arrl_dl_sf.png"
theme.arrl_sf  = theme.confdir .. "/widgets/arrl_sf.png"
-- {{{  Widget icons

-- theme.widget_sep = theme.confdir .. "/widgets/seperator.png"
theme.widget_uptime = theme.confdir .. "/widgets/ac_01.png"
theme.widget_cpu = theme.confdir .. "/widgets/cpu.png"
theme.widget_temp = theme.confdir .. "/widgets/temp.png"
theme.widget_mem = theme.confdir .. "/widgets/mem.png"
theme.widget_fs = theme.confdir .. "/widgets/diskette.png"
-- theme.widget_disk = theme.confdir .. "/widgets/yellow/usb.png"
-- theme.widget_myip = theme.confdir .. "/widgets/yellow/net_down_01.png"
-- theme.widget_spkr = theme.confdir .. "/widgets/spkr.png"
-- theme.widget_head = theme.confdir .. "/widgets/phones.png"
theme.widget_netwired = theme.confdir .. "/widgets/net_wired.png"
theme.widget_wifi = theme.confdir .. "/widgets/wifi_02.png"
theme.widget_netdown = theme.confdir .. "/widgets/net_down_03.png"
theme.widget_netup = theme.confdir .. "/widgets/net_up_03.png"
theme.widget_gmail = theme.confdir .. "/widgets/mail.png"
theme.widget_sys = theme.confdir .. "/widgets/arch_10x10.png"
-- theme.widget_newmail = theme.confdir .. "/widgets/newmail.png"
theme.widget_pac = theme.confdir .. "/widgets/pacman.png"
-- theme.widget_newpackage = theme.confdir .. "/widgets/newpackage.png"
theme.widget_batt = theme.confdir .. "/widgets/bat_full_01.png"
-- theme.widget_batt_low = theme.confdir .. "/widgets/bat_low.png"
-- theme.widget_batt_empty = theme.confdir .. "/widgets/bat_empty.png"
theme.widget_clock = theme.confdir .. "/widgets/clock.png"
theme.widget_sysload = theme.confdir .. "/widgets/info_01.png"
theme.widget_mpd = theme.confdir .. "/widgets/note.png"
theme.widget_play = theme.confdir .. "/widgets/play.png"
theme.widget_pause = theme.confdir .. "/widgets/pause.png"
theme.widget_stop = theme.confdir .. "/widgets/stop.png"
theme.widget_prev = theme.confdir .. "/widgets/prev.png"
theme.widget_next = theme.confdir .. "/widgets/next.png"
theme.widget_vol = theme.confdir .. "/widgets/spkr_01.png"
theme.widget_pandora = theme.confdir .. "/widgets/phones.png"

-- }}}

-- {{{ Taglist
--theme.taglist_squares_sel   = theme.confdir .. "/taglist/squaref_b.png"
--theme.taglist_squares_unsel = theme.confdir .. "/taglist/square_b.png"
theme.taglist_squares_unsel = theme.confdir .. "/taglist/square_unsel.png"
theme.taglist_squares_sel = theme.confdir .. "/taglist/square_sel.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc


theme.awesome_icon           = theme.confdir .. "/widgets/arch_10x10.png"
theme.menu_submenu_icon      = theme.confdir .. "/submenu.png"
theme.tasklist_floating_icon = theme.confdir .. "/floating.png"

-- }}}


-- {{{ Layout
theme.layout_tile       = theme.confdir .. "/layouts/tile.png"
theme.layout_tileleft   = theme.confdir .. "/layouts/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "/layouts/tiletop.png"
theme.layout_fairv      = theme.confdir .. "/layouts/fairv.png"
theme.layout_fairh      = theme.confdir .. "/layouts/fairh.png"
theme.layout_spiral     = theme.confdir .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/layouts/dwindle.png"
theme.layout_max        = theme.confdir .. "/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "/layouts/magnifier.png"
theme.layout_floating   = theme.confdir .. "/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.confdir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.confdir .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.confdir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.confdir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.confdir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.confdir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.confdir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.confdir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.confdir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.confdir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.confdir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.confdir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.confdir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/titlebar/maximized_normal_inactive.png"

-- }}}
-- }}}

return theme
