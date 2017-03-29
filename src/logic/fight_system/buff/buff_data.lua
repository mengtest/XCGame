-------------------
-- Buff管理
-------------------
module("fight", package.seeall)

clsBuffData = class("clsBuffData", clsDataFace)

clsBuffData:RegSaveVar("BuffId", TYPE_CHECKER.INT)			-- BuffId
clsBuffData:RegSaveVar("LastTime", TYPE_CHECKER.INT)		-- 持续多少秒
clsBuffData:RegSaveVar("Overlap", TYPE_CHECKER.INT)			-- 堆叠数量
clsBuffData:RegSaveVar("Owner", function(v) assert(v:GetUid()) end)	-- 拥有者

function clsBuffData:ctor(BuffId, LastTime, Owner)
	clsDataFace.ctor(self)
	self:SetBuffId(BuffId)
	self:SetLastTime(LastTime)
	self:SetOwner(Owner)
	self:SetOverlap(1)
end

function clsBuffData:dtor()
	
end

function clsBuffData:GetBuffCfg()
	return setting.T_buff.BuffInfoTbl[self:GetBuffId()]
end

function clsBuffData:IsOver()
	return false
end
