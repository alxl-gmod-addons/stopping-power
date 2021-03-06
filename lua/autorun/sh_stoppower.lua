local plymeta = FindMetaTable("Player")

function plymeta:GetStopPowerSlowdownMult()
    return self:GetNWFloat("stoppower_mult", 1.0)
end

function plymeta:GetStopPowerRecoveryTime()
    return self:GetNWFloat("stoppower_recov_delay")
end

hook.Add("Move", "StoppingPowerSpeedMult", function(ply, mv)
    local mult = ply:GetStopPowerSlowdownMult();
    -- According to the gmod docs, speed to 0.0 does nothing at all, so we'll set it to 0.01 instead
    mv:SetMaxSpeed(math.max(0.01, mv:GetMaxSpeed() * mult))
    mv:SetMaxClientSpeed(math.max(0.01, mv:GetMaxClientSpeed() * mult))
end)
