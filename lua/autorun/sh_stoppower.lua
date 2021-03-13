local plymeta = FindMetaTable("Player")

function plymeta:GetStopPowerSlowdownMult()
    return self:GetNWFloat("stoppower_mult", 1.0)
end

function plymeta:ResetStopPowerMult()
    self:SetNWFloat("stoppower_mult", 1.0)
end

function plymeta:GetRecoveryTime()
    return self:GetNWFloat("stoppower_recov_delay")
end

hook.Add("Move", "StoppingPowerSpeedMult", function(ply, mv)
    local speed = mv:GetMaxSpeed() * ply:GetStopPowerSlowdownMult()
    mv:SetMaxSpeed(speed)
    mv:SetMaxClientSpeed(speed)
end)
