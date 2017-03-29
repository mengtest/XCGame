-----------------
-- 法术球管理器
-----------------
module("missile",package.seeall)

local CFG_MISSILE = {
	["clsMissileStatic"] 	= require "src/logic/bullet/MissileStatic",
	["clsMissileLine"] 		= require "src/logic/bullet/MissileLine",
	["clsMissileParabola"] 	= require "src/logic/bullet/MissileParabola",
	["clsMissileTrack"] 	= require "src/logic/bullet/MissileTrack",
	["clsMissilePossessed"] = require "src/logic/bullet/MissilePossessed",
}

local _iMissileID = 0


ClsMissileMgr = class("ClsMissileMgr", clsCoreObject)

function ClsMissileMgr:ctor()
	clsCoreObject.ctor(self)
	
	self._tMissileList = {}
	self._tDelList = {}
	
	g_EventMgr:AddListener(self, "LEAVE_WORLD", function()
		self:DestroyAllMissiles()
	end)
end

function ClsMissileMgr:dtor()
	self:DestroyAllMissiles()
end

-- 创建法术体
function ClsMissileMgr:CreateMissile(theOwner, magicInfo)
	if not theOwner then return end
	_iMissileID = _iMissileID + 1 
	
	local cls = CFG_MISSILE[magicInfo.tTrackCfg.sTrackType]
	self._tMissileList[_iMissileID] = cls.new(_iMissileID, theOwner:GetUid())
	self._tMissileList[_iMissileID]:OnCreate(magicInfo)
	return self._tMissileList[_iMissileID]
end

-- 销毁法术体
function ClsMissileMgr:DestroyMissile(missile_id)
	if self._tMissileList[missile_id] then
		if self._bUpdateing then
			table.insert(self._tDelList, missile_id)
			return
		end
	
		KE_SafeDelete(self._tMissileList[missile_id])
		self._tMissileList[missile_id] = nil
	end
end

-- 销毁所有法术体
function ClsMissileMgr:DestroyAllMissiles()
	for _, missile in pairs(self._tMissileList) do
		KE_SafeDelete(missile)
	end
	self._tMissileList = {}
	
	self:ClearDelList()
end

function ClsMissileMgr:ClearDelList()
	local DelList = self._tDelList
	for _, missile_id in ipairs(DelList) do
		self:DestroyMissile(missile_id)
	end
	self._tDelList = {}
end

function ClsMissileMgr:SetLock(bLock)
	self._bUpdateing = bLock
end
