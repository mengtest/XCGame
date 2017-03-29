-------------------
-- 回合制
-------------------
module("fight", package.seeall)

clsCombatRound = class("clsCombatRound", clsCombat)

function clsCombatRound:ctor()
	clsCombat.ctor(self)
end

function clsCombatRound:CheckFinish()
	local bAllDead1 = self:IsTeamDie(1)
	if bAllDead1 then return true end
	
	local bAllDead2 = self:IsTeamDie(2)
	if bAllDead2 then return true end
	
	return false
end

function clsCombatRound:Judge()
	--我方全部阵亡：则输
	local bAllDead1 = self:IsTeamDie(1)
	if bAllDead1 then
		return false
	end
	
	--敌方全部阵亡：则赢
	local bAllDead2 = self:IsTeamDie(2)
	if bAllDead2 then
		return true
	end
	
	--双方都未全部阵亡：血量高于敌方则赢，否则输
	local InstRoleDataMgr = KE_Director:GetRoleDataMgr()
	local TeamList = ClsFightSystem.GetInstance():GetTeamList() 
	
	local TotalHP_1 = 0
	local RoleInfoList = TeamList[1]
	for _, RoleInfo in ipairs(RoleInfoList) do
		local RoleData = InstRoleDataMgr:GetRoleData(RoleInfo.Uid)
		TotalHP_1 = TotalHP_1 + RoleData:GetiCurHP()
	end
	
	local TotalHP_2 = 0
	local RoleInfoList = TeamList[2]
	for _, RoleInfo in ipairs(RoleInfoList) do
		local RoleData = InstRoleDataMgr:GetRoleData(RoleInfo.Uid)
		TotalHP_2 = TotalHP_2 + RoleData:GetiCurHP()
	end
	
	return TotalHP_1 > TotalHP_2
end
