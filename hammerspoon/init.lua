require('clipboard')

cmd_ctrl = {"cmd","ctrl"}

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)
hs.alert.show("Config loaded",3)

function positionFocusedWindow(layout)
    return function() hs.window:focusedWindow():moveToUnit(layout) end
end

local frameCache = {}
function toggle_window_maximized()
    local win = hs.window.focusedWindow()
    if frameCache[win:id()] then
        win:setFrame(frameCache[win:id()])
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end 

--Toggle an application between being the frontmost app, and being hidden
function toggleApplication(_app)
    local app = hs.appfinder.appFromName(_app)
    if not app then
        hs.application.launchOrFocus(_app)       -- FIXME: This should really launch _app
        return
    end
    local mainwin = app:mainWindow()
    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    end
end

hs.hotkey.bind('alt', 'x', toggle_window_maximized)
hs.hotkey.bind(cmd_ctrl, 'Left', positionFocusedWindow(hs.layout.left50))
hs.hotkey.bind(cmd_ctrl, 'Right', positionFocusedWindow(hs.layout.right50))
hs.hotkey.bind(cmd_ctrl, "Down", function()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)
hs.hotkey.bind(cmd_ctrl, "Up", function()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end)

hs.hotkey.bind('alt', "c", function()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.w - (max.w * 0.9)
    f.y = max.h - (max.h * 0.85)
    f.w = max.w * 0.8
    f.h = max.h * 0.8
    win:setFrame(f)
end)

local key2App = {
    t = 'Quiver',
    r = 'Safari',
    f = 'Finder',
    x = 'Tweetbot',
    c = 'Activity Monitor',
    e = 'iTerm',
    s = 'Google Chrome',
    z = 'Telegram Desktop',
}
for key, app in pairs(key2App) do
	--hs.hotkey.bind(cmd_ctrl, key, function() hs.application.launchOrFocus(app) end)
	hs.hotkey.bind(cmd_ctrl, key, function() toggleApplication(app) end)
end
hs.hotkey.bind(cmd_ctrl, 'j', function ()
    hs.alert.show('t > Quiver\n' ..
    'r > Safari\n' ..
    'f > Finder\n' ..
    'x > Tweetbot\n' ..
    'c > Activity Monitor\n' ..
    'e > iTerm\n' .. 
    's > Google Chrome\n' ..
    'z > Telegram Desktop'
    ,3) 
end)

local wifiWatcher = nil
local lastSSID = nil
function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()
    if newSSID ~= lastSSID then
        hs.notify.new({alwaysPresent=true,autoWithdraw=false,title='wifi changed',subTitle='new ssid: ' .. newSSID}):send()
        hs.alert.show("wifi changed to: " .. newSSID,5)
    else
    end
    lastSSID = newSSID
end
wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

local usbWatcher = nil
function usbDeviceCallback(data)
    if (data["productName"] == "HHKB Professional") then
        if (data["eventType"] == "added") then
            --hs.notify.show('hhkb','hhkb on','hhkb on')
            hs.notify.new({alwaysPresent=true,autoWithdraw=false,title='HHKB',subTitle='HHKB on'}):send()
            hs.alert.show("hhkb on, built-in disabled.",5)
        elseif (data["eventType"] == "removed") then
            hs.notify.new({alwaysPresent=true,autoWithdraw=false,title='HHKB',subTitle='HHKB off'}):send()
            hs.alert.show("hhkb off, built-in enabled.",5)
        end
    end
end
usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()
