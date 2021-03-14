local plymeta = FindMetaTable("Player")

function plymeta:GetStopPowerSlowdownMult()
    return self:GetNWFloat("stoppower_mult", 1.0)
end

function plymeta:GetStopPowerRecoveryTime()
    return self:GetNWFloat("stoppower_recov_delay")
end

hook.Add("Move", "StoppingPowerSpeedMult", function(ply, mv)
    -- Setting speed to 0.0 does nothing at all, so we'll set it
    local speed = math.max(0.01, mv:GetMaxClientSpeed() * ply:GetStopPowerSlowdownMult())
    mv:SetMaxSpeed(speed)
    mv:SetMaxClientSpeed(speed)
end)
