local msg = require "mp.msg"
local utils = require "mp.utils"
local options = require "mp.options"

local cut_pos = nil
local copy_audio = true

function timestamp(duration)
    local hours = duration / 3600
    local minutes = duration % 3600 / 60
    local seconds = duration % 60
    return string.format("%02d:%02d:%02.03f", hours, minutes, seconds)
end

function osd(str)
    return mp.osd_message(str, 3)
end

function escape(str)
    return str:gsub("\\", "\\\\"):gsub("'", "'\\''")
end

function trim(str)
    return str:gsub("^%s+", ""):gsub("%s+$", "")
end

function get_csp()
    local csp = mp.get_property("colormatrix")
    if csp == "bt.601" then return "bt601"
        elseif csp == "bt.709" then return "bt709"
        elseif csp == "smpte-240m" then return "smpte240m"
        else
            local err = "Unknown colorspace: " .. csp
            osd(err)
            error(err)
    end
end

function get_outname(shift, endpos)
    local name = mp.get_property("filename")
    local dotidx = name:reverse():find(".", 1, true)
    if dotidx then name = name:sub(1, -dotidx-1) end
    name = name:gsub(" ", "_")
    name = name .. string.format(".%s-%s", timestamp(shift), timestamp(endpos))
    return name
end

function cut(shift, endpos)
    local inpath = escape(utils.join_path(
        utils.getcwd(),
        mp.get_property("stream-path")))
    -- TODO: Windows?
    --local outpath = os.getenv("HOME")..'/Desktop/' ..
        --get_outname(shift, endpos)
    local outpath = utils.join_path(os.getenv("HOME"), 'Desktop/output.mp4')
    t = {}
    t.args={
        'ffmpeg',
        '-v', 'warning',
        '-y', '-stats',
        '-ss', shift, 
        '-i', inpath, 
        '-t', endpos-shift,
        '-vcodec', 'copy',
        '-acodec', 'copy',
        outpath
    }
    msg.info(t.args)
    msg.info(outpath)
    osd('Loading')
    ret = utils.subprocess_detached(t)
    if ret.status == 0 then
        osd('Done')
    else
        osd('Failed')
    end
end

function toggle_mark()
    local pos = mp.get_property_number("time-pos")
    if cut_pos then
        local shift, endpos = cut_pos, pos
        if shift > endpos then
            shift, endpos = endpos, shift
        end
        if shift == endpos then
            osd("Cut fragment is empty")
        else
            cut_pos = nil
            osd(string.format("Cut fragment: %s - %s",
                timestamp(shift),
                timestamp(endpos)))
            cut(shift, endpos)
        end
    else
        cut_pos = pos
        osd(string.format("Marked %s as start position", timestamp(pos)))
    end
end

function toggle_audio()
    copy_audio = not copy_audio
    osd("Audio capturing is " .. (copy_audio and "enabled" or "disabled"))
end

mp.add_key_binding("Ctrl+x", "slicing_mark", toggle_mark)
mp.add_key_binding("Ctrl+a", "slicing_audio", toggle_audio)
