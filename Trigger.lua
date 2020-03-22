function(allstates, event, prefix, message, channel, sender)
    local COMM_PREFIX = "LHC40"
    local debug = true
    
    local function parseDirectHeal(casterGUID, spellID, amount, castTime, destGUID)
        local spellName = GetSpellInfo(spellID)
        local healers, tanks, healer, tank
        healers = {
            ["4474-01B77F35"] = "Healer",
        }
        tanks = {
            ["4474-01B77F35"] = "Tank",
        }
        if healers[casterGUID] and tanks[destGUID] then
            healer = healers[casterGUID]
            tank = tanks[destGUID]
        end
        if( not healer or not spellName or not amount or not tank ) then return end        
        endTime = GetTime() + (castTime or 1.5)
        if debug then print("HEAL:",healer, spellName, castTime or 1.5, amount, tank) end
        -- local allstates = {}
        allstates[healer] = {
            show = true,
            changed = true,
            progressType = "timed",
            duration = castTime or 1.5,
            expirationTime = endTime,
            name = spellName,
            -- icon = icon,
            caster = healer,
            autoHide = true,
            additionalProgress = {
                {
                    min = 0,
                    max = 20
                },
                {
                    direction = "forward",
                    width = 50,
                    offset = 20
                },
            }
        }
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
    return true
end
