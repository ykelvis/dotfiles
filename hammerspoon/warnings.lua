local bash = "/bin/bash"
local swap_cli = {"-c", "ls -al /private/var/vm/swap*|wc -l"}
local telegram_cli = {"-c", "ps -ef -m -o command,rss|grep -i telegram|grep -v grep|head -1|awk '{print $NF}'"}
local SWAP_UPDATE_TIMER = 300
local TELEGRAM_UPDATE_TIMER = 30
local swap = nil
local telegram = nil

local function swap_update_callback(exit_code, std_out, std_err)
    if tonumber(std_out) > 6 then
        hs.notify.show('Swap', 'BOOM!', ''):send()
        hs.alert("swap boom")
        return
    end
end
local function swap_do_update()
    if not swap or not swap:isRunning() then
        swap = hs.task.new(bash, swap_update_callback, swap_cli)
        swap:start()
    end
end
local swap_timer = hs.timer.doEvery((SWAP_UPDATE_TIMER * 1), swap_do_update)
swap_do_update()

local function telegram_update_callback(exit_code, std_out, std_err)
    if std_out == '' then
        return
    end
    if tonumber(std_out) > 2048000 then
        hs.notify.show('Telegram', 'BOOM!', ''):send()
        hs.alert("telegram boom")
        return
    end
end
local function telegram_do_update()
    if not telegram or not telegram:isRunning() then
        telegram = hs.task.new(bash, telegram_update_callback, telegram_cli)
        telegram:start()
    end
end
local telegram_timer = hs.timer.doEvery((TELEGRAM_UPDATE_TIMER * 1), telegram_do_update)
telegram_do_update()

