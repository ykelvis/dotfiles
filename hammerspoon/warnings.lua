local bash = "/bin/bash"
local swap = {"-c", "ls -al /private/var/vm/swap*|wc -l"}
local SWAP_UPDATE_TIMER = 300
local swaps = nil

local function update_callback(exit_code, std_out, std_err)
    if tonumber(std_out) > 6 then
        hs.notify.show('Swap', 'BOOM!', ''):send()
        hs.alert("swap boom")
        return
    end
end

local function do_update()
    if not swaps or not swaps:isRunning() then
        swaps = hs.task.new(bash, update_callback, swap)
        swaps:start()
    end
end

local stocker_timer = hs.timer.doEvery((SWAP_UPDATE_TIMER * 1), do_update)
do_update()
