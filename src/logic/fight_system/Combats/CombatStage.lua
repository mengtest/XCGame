-------------------
-- 闯关战
-------------------
module("fight", package.seeall)

clsCombatStage = class("clsCombatStage", clsCombat)

function clsCombatStage:ctor()
	clsCombat.ctor(self)
end

function clsCombatStage:CheckFinish()
	local bAllDead1 = self:IsTeamDie(1)
	if bAllDead1 then return true end
	
	local bAllDead2 = self:IsTeamDie(2)
	if bAllDead2 then return true end
	
	return false
end

function clsCombatStage:Judge()
	return self:IsTeamDie(2)
end
