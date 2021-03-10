local plymeta = FindMetaTable("Player")

function plymeta:SetStopPowerSlowdownMult(mult)
    self:SetNWFloat("stoppower_mult", mult)
end

function plymeta:GetStopPowerSlowdownMult()
    return self:GetNWFloat("stoppower_mult", 1.0)
end

function plymeta:ChangeStopPowerSlowdownMult(by, minAllowed)
    self:SetStopPowerSlowdownMult(math.min(1.0, math.max(minAllowed, self:GetStopPowerSlowdownMult() + by)))
end

function plymeta:ApplyStopPowerSlowdownMult()
    local cmult = self:GetStopPowerSlowdownMult() / self:GetNWFloat("stoppower_mult_prev", 1.0)

    self:SetRunSpeed(self:GetRunSpeed() * cmult)
    self:SetWalkSpeed(self:GetWalkSpeed() * cmult)
    self:SetSlowWalkSpeed(self:GetSlowWalkSpeed() * cmult)
    self:SetJumpPower(self:GetJumpPower() * cmult)

    self:SetNWFloat("stoppower_mult_prev", self:GetStopPowerSlowdownMult())
end

function plymeta:ResetStopPowerMult()
    self:SetNWFloat("stoppower_mult", 1.0)
    self:SetNWFloat("stoppower_mult_prev", 1.0)
end

function plymeta:SetRecoveryTime(t)
    self:SetNWFloat("stoppower_recov_delay", t)
end

function plymeta:GetRecoveryTime()
    return self:GetNWFloat("stoppower_recov_delay")
end
