-------------------
-- 攻城战
-------------------
module("fight", package.seeall)

clsCombatCitySiege = class("clsCombatCitySiege", clsCombat)

function clsCombatCitySiege:ctor()
	clsCombat.ctor(self)
end

function clsCombatCitySiege:CheckFinish()
	local bAllDead1 = self:IsTeamDie(1)
	if bAllDead1 then return true end
	
	local bAllDead2 = self:IsTeamDie(2)
	if bAllDead2 then return true end
	
	return false
end

function clsCombatCitySiege:Judge()
	return self:IsTeamDie(2)
end
