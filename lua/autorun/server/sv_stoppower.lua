local function resetAllPlayers()
    for _, ply in ipairs(player.GetAll()) do
        ply:ResetStopPowerMult()
    end
end

concommand.Add("stoppower_reset_all_players", function(ply, cmd, args)
    resetAllPlayers()
end)

CreateConVar("stoppower_enable", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY,
    "When 1, taking damage will slow down players. Turn off with 0.", 0, 1)
local enabled = GetConVar("stoppower_enable"):GetBool()
cvars.AddChangeCallback("stoppower_enable", function()
    enabled = GetConVar("stoppower_enable"):GetBool()

    if not enabled then
        resetAllPlayers()
    end
end)

CreateConVar("stoppower_tick_time", 0.05, FCVAR_ARCHIVE, "How frequently slowdown updates.")
local tickTime = GetConVar("stoppower_tick_time"):GetFloat()
cvars.AddChangeCallback("stoppower_tick_time", function()
    tickTime = GetConVar("stoppower_tick_time"):GetFloat()
end)

CreateConVar("stoppower_minimum_speed_mult", 0.1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The slowest slowdown amount allowed.")
local multMin = GetConVar("stoppower_minimum_speed_mult"):GetFloat()
cvars.AddChangeCallback("stoppower_minimum_speed_mult", function()
    multMin = GetConVar("stoppower_minimum_speed_mult"):GetFloat()
end)

CreateConVar("stoppower_recovery_speed", 0.66, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The slowdown recovered every second.")
local recovAmt = GetConVar("stoppower_recovery_speed"):GetFloat()
cvars.AddChangeCallback("stoppower_recovery_speed", function()
    recovAmt = GetConVar("stoppower_recovery_speed"):GetFloat()
end)

CreateConVar("stoppower_recovery_delay", 0.5, FCVAR_ARCHIVE + FCVAR_NOTIFY,
    "The number of seconds before recovery starts.")
CreateConVar("stoppower_autoreset_type", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "0=no auto-reset, 1=on spawn, 2=on death")

hook.Add("PostPlayerDeath", "StoppingPowerDeathReset", function(ply)
    if enabled and GetConVar("stoppower_recovery_delay"):GetInt() == 1 then
        ply:ResetStopPowerMult()
    end
end)

hook.Add("PlayerSpawn", "StoppingPowerSpawnReset", function(ply, transition)
    if enabled and GetConVar("stoppower_recovery_delay"):GetInt() == 2 then
        ply:ResetStopPowerMult()
    end
end)

CreateConVar("stoppower_dmg_mult", 0.05, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The base slowdown amount per damage taken.")
CreateConVar("stoppower_dmg_mult_armor", 0.8, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by damage taken when you have any armor.")
CreateConVar("stoppower_dmg_mult_bullet", 1.0, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by conventional bullets.")
CreateConVar("stoppower_dmg_mult_drown", 0.0, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by drowning damage.")
CreateConVar("stoppower_dmg_mult_energy", 0.9, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by lasers, plasma, electricity, etc.")
CreateConVar("stoppower_dmg_mult_explosion", 1.1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by explosions.")
CreateConVar("stoppower_dmg_mult_falling", 0.25, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by falling.")
CreateConVar("stoppower_dmg_mult_fire", 0.9, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by fire.")
CreateConVar("stoppower_dmg_mult_impact", 1.1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by props and blunt melee attacks.")
CreateConVar("stoppower_dmg_mult_poison", 0.1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by poison (e.g. from poison headcrabs).")
CreateConVar("stoppower_dmg_mult_slash", 1.0, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by slashes (includes almost all HL2 NPC melee attacks).")
CreateConVar("stoppower_dmg_mult_toxin", 0.9, FCVAR_ARCHIVE + FCVAR_NOTIFY, "The multiplier for slowdown caused by acid, radiation, etc.")

hook.Add("PostEntityTakeDamage", "StoppingPowerSlowdown", function(ent, dmg, took)
    if enabled and took and ent:IsPlayer() then
        local dmgMult = GetConVar("stoppower_dmg_mult"):GetFloat()
        if ent:Armor() > 0 then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_armor"):GetFloat()
        end
        if dmg:IsBulletDamage() then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_bullet"):GetFloat()
        end
        if dmg:IsDamageType(DMG_DROWN) then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_drown"):GetFloat()
        end
        if dmg:IsDamageType(DMG_SHOCK) or dmg:IsDamageType(DMG_SONIC) or dmg:IsDamageType(DMG_ENERGYBEAM) or dmg:IsDamageType(DMG_PLASMA)  or dmg:IsDamageType(DMG_PHYSGUN) then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_energy"):GetFloat()
        end
        if dmg:IsExplosionDamage() then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_explosion"):GetFloat()
        end
        if dmg:IsFallDamage() then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_falling"):GetFloat()
        end
        if dmg:IsDamageType(DMG_BURN) or dmg:IsDamageType(DMG_SLOWBURN) then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_fire"):GetFloat()
        end
        if dmg:IsDamageType(DMG_CLUB) or dmg:IsDamageType(DMG_CRUSH) or dmg:IsDamageType(DMG_GENERIC) or dmg:IsDamageType(DMG_VEHICLE) then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_impact"):GetFloat()
        end
        if dmg:IsDamageType(DMG_POISON) or dmg:IsDamageType(DMG_PARALYZE) then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_poison"):GetFloat()
        end
        if dmg:IsDamageType(DMG_SLASH) then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_slash"):GetFloat()
        end
        if dmg:IsDamageType(DMG_NERVEGAS) or dmg:IsDamageType(DMG_RADIATION) or dmg:IsDamageType(DMG_ACID) then
            dmgMult = dmgMult * GetConVar("stoppower_dmg_mult_toxin"):GetFloat()
        end

        if dmgMult > 0.0 then
            ent:ChangeStopPowerSlowdownMult(-dmgMult * dmg:GetDamage(), multMin)
            ent:SetStopPowerRecoveryTime(CurTime() + GetConVar("stoppower_recovery_delay"):GetFloat())
        end
    end
end)

local lastRecovTick = 0.0
hook.Add("Tick", "StoppingPowerRecovery", function()
    if enabled then
        local delta = CurTime() - lastRecovTick

        if delta >= tickTime then
            lastRecovTick = CurTime()
            local recov = delta * recovAmt

            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() then
                    local pRecovTick = ply:GetStopPowerRecoveryTime()
                    if pRecovTick and lastRecovTick >= pRecovTick then
                        ply:ChangeStopPowerSlowdownMult(recov, multMin)
                    end
                end
            end
        end
    end
end)
