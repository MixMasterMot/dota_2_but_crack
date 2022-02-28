if item_blink_staff == nil then
    item_blink_staff = class({})
end

function item_blink_staff:GetBehavior()
    local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
    return behav
end

function item_blink_staff:GetManaCost()
    return 0
end

function item_blink_staff:GetCooldown( nLevel )
    return 0
end

function item_blink_staff:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local hTarget = false --We might not have target so we make fail-safe so we do not get an error when calling - self:GetCursorTarget()
    if not self:GetCursorTargetingNothing() then
        hTarget = self:GetCursorTarget()
    end
    local vPoint = self:GetCursorPosition() --We will always have Vector for the point.
    local vOrigin = hCaster:GetAbsOrigin() --Our caster's location
    local nMaxBlink = 1200 --How far can we actually blink?
    local nClamp = 960 --If we try to over reach we use this value instead. (this is mechanic from blink dagger.)

    ProjectileManager:ProjectileDodge(hCaster)  --We disjoint disjointable incoming projectiles.
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hCaster) --Create particle effect at our caster.
    hCaster:EmitSound("DOTA_Item.BlinkDagger.Activate") --Emit sound for the blink
    local vDiff = vPoint - vOrigin --Difference between the points
    if vDiff:Length2D() > nMaxBlink then  --Check caster is over reaching.
        vPoint = vOrigin + (vPoint - vOrigin):Normalized() * nClamp -- Recalculation of the target point.
    end
    hCaster:SetAbsOrigin(vPoint) --We move the caster instantly to the location
    FindClearSpaceForUnit(hCaster, vPoint, false) --This makes sure our caster does not get stuck
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, hCaster) --Create particle effect at our caster.
end