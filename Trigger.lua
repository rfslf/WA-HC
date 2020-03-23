function(allstates, event, prefix, message, channel, sender)
    local COMM_PREFIX = "LHC40"
    local debug = false
    local healers, tanks
    healers = {
        ["4474-01B77F35"] = "Вирга",
        ['4474-011A6F4A'] = "Абабусдубу",
        ["4474-024C054B"] = "Тичми",
        ["4474-00B4FBD8"] = "Алиссия",
        ["4474-0129C951"] = 'Офлайн',
        ["4474-023D7146"] = "Фармазолинка",
        ["4474-00019EAC"] = "Ланнистер",
    }
    tanks = {
        -- ["4474-01B77F35"] = "Вирга",
        -- ['4474-011A6F4A'] = "Абабусдубу",
        ["4474-023FAC61"] = "Каздэлл",
    }   
    local healer, tank
    
    local function parseDirectHeal(casterGUID, spellID, amount, castTime, destGUID)
        if healers[casterGUID] and tanks[destGUID] then
            healer = healers[casterGUID]
            tank = tanks[destGUID]
            
            local spellName, _, icon = GetSpellInfo(spellID)
            
            castTime = tonumber(castTime) + 0.3
            if( not healer or not spellName or not amount or not tank ) then return end        
            endTime = GetTime() + (castTime or 1.5)
            if debug then print("HEAL:",healer, spellName, castTime or 1.5, amount, tank) end
            allstates[healer] = allstates[healer] or {} -- error checking
            local state = allstates[healer]
            state.show = true
            state.changed = true
            state.progressType = "timed"
            state.duration = castTime or 1.5
            state.expirationTime = endTime
            state.name = spellName
            state.icon = icon
            state.caster = healer
            state.target = tank
            state.amount = amount
            state.landed = ""
            state.autoHide = true
        end    
    end 
    
    if (prefix ~= COMM_PREFIX) then return false end
    if debug then print("RCV:", prefix, message, channel, sender) end
    local commType, extraArg, spellID, arg1, arg2, arg3, arg4 = strsplit(":", message)
    local casterGUID = UnitGUID(Ambiguate(sender, "none"))
    casterGUID = string.sub(casterGUID, 8)
    spellID = tonumber(spellID)
    if debug then print("MSG:",casterGUID, commType, extraArg, spellID, arg1, arg2, arg3, arg4) end
    
    if (not commType or not spellID or not casterGUID ) then
        return false
    end
    if( commType == "D" and arg1 and arg2 ) then    
        parseDirectHeal(casterGUID, spellID, tonumber(arg1), extraArg, strsplit(",", arg2))
    end
    
    if( commType == "S") then
        -- local interrupted = arg1 == "1" and true or false
        if arg1 then
            if healers[casterGUID] then
                healer = healers[casterGUID]
                allstates[healer] = allstates[healer] or {} -- error checking
                local state = allstates[healer]
                state.show = false
                state.changed = true
                --state.landed = "DONE"
            end
        end
    end
    return true
end

