-------------------
-- 游戏内所有对象的id的分配和管理
--[[
游戏内所有obj的Id只允许是以下两类之一：
	1. Pid  游戏进程生命期内唯一,此类id不存盘
	2. Uid  游戏生命周期内唯一，可能需存盘(玩家的Uid在同组服务器内都是唯一的!)

	Pid用于表示记录不需要存盘的obj间的关系,如当前玩家可以看到哪些npc
	Uid用于表示记录需要存盘的obj间的关系,如当前玩家拥有哪些物品和宠物
]]
-------------------
module("idmng", package.seeall)

-- 存盘数据
local SAVE_VARS = {
	["UserUid"] 	= { const.PLAYER_ID_BEGIN, const.PLAYER_ID_END },
	["NpcUid"] 		= { const.NPC_ID_BEGIN, const.NPC_ID_END },
	["ItemUid"] 	= {1},
	["CountryUid"] 	= {10000},		-- 1w以下是系统国家，1w以上是玩家创建的国家
}
-- 非存盘数据
local TMP_VARS = {
	["CombatPid"]	= {1},
	["TeamPid"]		= {1},
	["SceneMapPid"]	= {10000},		-- 1w以下的是固定场景，1w以上的是动态场景
	["MonsterPid"] 	= { const.MONSTER_ID_BEGIN, const.MONSTER_ID_END },
}

function RegisterSaveVars(self)
	for IdName, value in pairs(SAVE_VARS) do
		-- eg: InitUserUid()
		self["Init"..IdName] = function(SelfObj)
			local varName = "_Cur_"..IdName
			assert(not self[varName], "重复初始化："..IdName)
			
			self._save_info = table.force_load( string.format("%s/idinfo.lua",cache.GetWritablePath()) )
			self._save_info[varName] = self._save_info[varName] or SAVE_VARS[IdName][1]
			table.save( self._save_info, string.format("%s/idinfo.lua",cache.GetWritablePath()) )
			
			self[varName] = self._save_info[varName] 
			self[varName] = self[varName] + 1
			if SAVE_VARS[IdName][2] then assert(self[varName]<=SAVE_VARS[IdName][2], "超出了最大值: "..IdName) end
			return self[varName]
		end
		
		-- eg: GenUserUid()
		self["Gen"..IdName] = function(SelfObj)
			local varName = "_Cur_"..IdName
			self[varName] = self[varName] + 1
			if TMP_VARS[IdName][2] then assert(self[varName]<=TMP_VARS[IdName][2], "超出了最大值: "..IdName) end
			
			self._save_info[varName] = self[varName]
			table.save( self._save_info, string.format("%s/idinfo.lua",cache.GetWritablePath()) )
			
			return self[varName]
		end
		
		-- 执行初始化
		self["Init"..IdName](self)
	end
end

function RegisterTmpVars(self)
	for IdName, value in pairs(TMP_VARS) do
		-- eg: GenMonsterPid()
		self["Gen"..IdName] = function(SelfObj)
			local varName = "_Cur_"..IdName
			self[varName] = self[varName] or TMP_VARS[IdName][1]
			self[varName] = self[varName] + 1
			if TMP_VARS[IdName][2] then assert(self[varName]<=TMP_VARS[IdName][2], "超出了最大值") end
			return self[varName]
		end
	end
end

idmng:RegisterTmpVars()
idmng:RegisterSaveVars()
