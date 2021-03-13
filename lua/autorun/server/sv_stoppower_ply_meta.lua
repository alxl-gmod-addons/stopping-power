local plymeta = FindMetaTable("Player")

function plymeta:SetStopPowerSlowdownMult(mult)
    self:SetNWFloat("stoppower_mult", mult)
end

function plymeta:ChangeStopPowerSlowdownMult(by, minAllowed)
    self:SetStopPowerSlowdownMult(math.min(1.0, math.max(minAllowed, self:GetStopPowerSlowdownMult() + by)))
end

function plymeta:SetRecoveryTime(t)
    self:SetNWFloat("stoppower_recov_delay", t)
end
