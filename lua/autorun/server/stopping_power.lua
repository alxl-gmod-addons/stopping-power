CreateConVar("stoppower_enable", 1, FCVAR_NOTIFY, "When 1, taking damage will slow down players. Turn off with 0.", 0, 1)
local enabled = GetConVar("stoppower_enable"):GetBool()
cvars.AddChangeCallback("stoppower_enable", function()
    enabled = GetConVar("stoppower_enable"):GetBool()

    if not enabled then
        resetAllPlayers()
    end
end)

CreateConVar("stoppower_dmg_mult", 0.08, FCVAR_NOTIFY, "The slowdown amount per damage taken.")
local dmgMult = GetConVar("stoppower_dmg_mult"):GetFloat()
cvars.AddChangeCallback("stoppower_dmg_mult", function()
    dmgMult = GetConVar("stoppower_dmg_mult"):GetFloat()
end)

CreateConVar("stoppower_minimum_speed_mult", 0.1, FCVAR_NOTIFY, "The slowest slowdown amount allowed.")
local multMin = GetConVar("stoppower_minimum_speed_mult"):GetFloat()
cvars.AddChangeCallback("stoppower_minimum_speed_mult", function()
    multMin = GetConVar("stoppower_minimum_speed_mult"):GetFloat()
end)

CreateConVar("stoppower_recovery_speed", 0.75, FCVAR_NOTIFY, "The slowdown recovered every second.")
local recovAmt = GetConVar("stoppower_recovery_speed"):GetFloat()
cvars.AddChangeCallback("stoppower_recovery_speed", function()
    recovAmt = GetConVar("stoppower_recovery_speed"):GetFloat()
end)

CreateConVar("stoppower_recovery_delay", 0.5, FCVAR_NOTIFY, "The number of seconds before recovery starts.")

hook.Add("PlayerHurt", "StoppingPowerSlowdown", function(ply, attacker, hpRemain, dmgTaken)
    ply:ChangeStopPowerSlowdownMult(-dmgMult * dmgTaken, multMin)
    ply:SetRecoveryTime(CurTime() + GetConVar("stoppower_recovery_delay"):GetFloat())
end)

hook.Add("PostPlayerDeath", "StoppingPowerReset", function(ply)
    ply:ResetStopPowerMult()
end)

local lastRecovTick = 0.0
local recovTickDur = 0.05
hook.Add("Tick", "StoppingPowerSpeedup", function()
    local delta = CurTime() - lastRecovTick

    if delta >= recovTickDur then
        lastRecovTick = CurTime()
        local recov = delta * recovAmt

        for _, ply in ipairs(player.GetAll()) do
            ply:ApplyStopPowerSlowdownMult(multMin)

            local pRecovTick = ply:GetRecoveryTime()
            if pRecovTick and lastRecovTick >= pRecovTick then
                ply:ChangeStopPowerSlowdownMult(recov, multMin)
            end
        end
    end
end)

function resetPlayer(ply)
    ply:ResetStopPowerMult()
    ply:ApplyStopPowerSlowdownMult(1.0)
end

function resetAllPlayers()
    for _, ply in ipairs(player.GetAll()) do
        resetPlayer(ply)
    end
end

concommand.Add("stoppower_reset_all_players", function(ply, cmd, args)
    resetAllPlayers()
end)
