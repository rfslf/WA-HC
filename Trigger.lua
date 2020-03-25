-- version 1
function(allstates, event, prefix, message, channel, sender)
    local COMM_PREFIX = "LHC40" -- prefix for healComm library messages
    local debug = false -- For debug messages, not for retail
    local delay = 0.1 -- Your dalay in ms
    local healers, tanks, healer, tank
    healers = {
        ["4474-01B77F35"] = "Вирга",
        ['4474-011A6F4A'] = "Абабусдубу",
        ["4474-024C054B"] = "Тичми",
        ["4474-00B4FBD8"] = "Алиссия",
        ["4474-0129C951"] = 'Офлайн',
        ["4474-023D7146"] = "Фармазолинка",
        ["4474-00019EAC"] = "Ланнистер",
        ["4474-01383AE9"] = "Растрахан",
    }
    tanks = {
        --["4474-01B77F35"] = "Вирга",
        --['4474-011A6F4A'] = "Абабусдубу",
        ["4474-023FAC61"] = "Каздэлл",
        --["4474-006630D4"] = "Мунг",
    }   
    
    local function parseDirectHeal(caster, spellID, amount, castTime, destGUID)
        if caster and tanks[destGUID] then
            tank = tanks[destGUID]            
            local spellName, _, icon = GetSpellInfo(spellID)
            castTime = tonumber(castTime) + 0.5 - delay        
            if( not spellName or not amount or not tank ) then return end        
            endTime = GetTime() + (castTime or 1.5)
            if debug then print("HEAL:",caster, spellName, castTime or 1.5, amount, tank) end
            allstates[caster] = allstates[caster] or {} -- error checking
            local state = allstates[caster]
            state.show = true
            state.changed = true
            state.progressType = "timed"
            state.duration = castTime or 1.5
            state.expirationTime = endTime
            state.name = spellName
            state.icon = icon
            state.caster = caster
            state.target = tank
            state.amount = amount
            state.failed = ""
            state.autoHide = true
        end    
    end 
    
    if (prefix ~= COMM_PREFIX) then return false end
    -- if debug then print("RCV:", prefix, message, channel, sender) end
    local commType, extraArg, spellID, arg1, arg2, arg3, arg4 = strsplit(":", message)
    local casterGUID = UnitGUID(Ambiguate(sender, "none"))
    casterGUID = string.sub(casterGUID, 8)
    spellID = tonumber(spellID)
    if debug then print("MSG:",casterGUID, commType, extraArg, spellID, arg1, arg2, arg3, arg4) end   
    if (not commType or not spellID or not casterGUID ) then return false end
    
    healer = healers[casterGUID]
    if( commType == "D" and arg1 and arg2 ) then    
        parseDirectHeal(healer, spellID, tonumber(arg1), extraArg, strsplit(",", arg2))
    elseif( commType == "S") then
        if arg1 then
            if healer then
                allstates[healer] = allstates[healer] or {} -- error checking
                local state = allstates[healer]
                state.amount = ""
                state.failed = "FAILED"
                state.duration = 0.3
                state.changed = true               
            end
        end
    elseif( commType ==  "F") then
        local state = allstates[healer]
        state.changed = true
        state.expirationTime = arg2 + GetTime()
    end
    return true
end

