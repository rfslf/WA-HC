function(allstates, event, prefix, message, channel, sender)
    local COMM_PREFIX = "LHC40" -- prefix for healComm library messages
    local debug = false -- For debug messages, not for retail
    local delay = 0.2 -- Your dalay in ms
    local healer, tank
    
    local function parseDirectHeal(caster, spellID, amount, castTime, destGUID)
        if caster and aura_env.tanks[destGUID] then
            tank = aura_env.tanks[destGUID]            
            local spellName, _, icon = GetSpellInfo(spellID)
            castTime = tonumber(castTime) + 0.5 - delay
            if( not spellName or not amount or not tank ) then return end        
            local endTime = GetTime() + (castTime or 1.5)
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
    
    if (event == "GROUP_ROSTER_UPDATE" and (GetTime() - aura_env.lastStateUpdate) > 1) then
        aura_env.lastStateUpdate = GetTime()
        
        for i = 1, 40 do
            local unitName = UnitName("raid"..i);
            local class = select(2,UnitClass("raid"..i))
            local _,_,_,_,_,_,zone,online,isDead = GetRaidRosterInfo(i)
            local isUnitValid = (class == "DRUID" or class == "PALADIN" or class == "PRIEST" or class == "SHAMAN")
            
            if isUnitValid then
                local healcomGUID = string.sub(UnitGUID(unitName), 8)
                aura_env.healers[healcomGUID] = unitName             
                if debug then print(aura_env.healers[healcomGUID]) end
            end
            
            if aura_env.targets[unitName] then
                local healcomGUID = string.sub(UnitGUID(unitName), 8)
                aura_env.tanks[healcomGUID] = unitName             
                if debug then print(aura_env.tanks[healcomGUID]) end
            end
        end
    else        
        if (prefix ~= COMM_PREFIX) then return false end
        -- if debug then print("RCV:", prefix, message, channel, sender) end
        local commType, extraArg, spellID, arg1, arg2, arg3, arg4 = strsplit(":", message)
        local casterGUID = UnitGUID(Ambiguate(sender, "none"))
        casterGUID = string.sub(casterGUID, 8)
        spellID = tonumber(spellID)
        if debug then print("MSG:",casterGUID, commType, extraArg, spellID, arg1, arg2, arg3, arg4) end   
        if (not commType or not spellID or not casterGUID ) then return false end  
        healer = aura_env.healers[casterGUID]
        
        if( commType == "D" and arg1 and arg2 ) then
            parseDirectHeal(healer, spellID, tonumber(arg1), extraArg, strsplit(",", arg2))
        elseif( commType == "S") then
            if arg1 then
                if healer then
                    allstates[healer] = allstates[healer] or {} -- error checking
                    local state = allstates[healer]
                    state.amount = ""
                    state.failed = "FAILED"
                    state.duration = 0.2
                    state.changed = true               
                end
            end
        elseif( commType ==  "F") then
            if healer then
                allstates[healer] = allstates[healer] or {} -- error checking
                local state = allstates[healer]
                state.changed = true
                state.expirationTime = arg2 + GetTime()
            end
        end
        return true
    end
end

