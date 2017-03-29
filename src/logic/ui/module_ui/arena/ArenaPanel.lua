-----------------
-- 竞技场
-----------------
module("ui", package.seeall)

local clsArenaItem = class("clsArenaItem", clsWindow)

function clsArenaItem:ctor(parent, idx)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_arena/arena_item.lua")
	
	self._idx = idx
	
	utils.RegButtonEvent(self:GetCompByName("btn_man"), function()
		local UserId = self._Uid
		if not UserId then utils.TellMe("不存在该角色") return end
		network.SendPro("s_fight_arena", nil, UserId)
	end)
	
	KE_Director:GetRoleDataMgr():AddListener(self, "update_role_data", function(Uid, RoleData)
		if Uid == self._Uid then
			self:GetCompByName("label_name"):setString(RoleData:GetsName())
			
			if self.mUiRole then
				ClsRoleMgr.GetInstance():DestroyTempRole(self.mUiRole) 
				self.mUiRole = nil
			end
			self.mUiRole = ClsRoleMgr.GetInstance():CreateTempRole(RoleData:GetTypeId())
			KE_SetParent(self.mUiRole, self:GetCompByName("btn_man"))
			self.mUiRole:ShowName(false)
			self.mUiRole:setScale(1.5)
			self.mUiRole:setPosition(101,140)
		end
	end)
end

function clsArenaItem:dtor()
	KE_Director:GetRoleDataMgr():DelListener(self)
	if self.mUiRole then
		ClsRoleMgr.GetInstance():DestroyTempRole(self.mUiRole) 
		self.mUiRole = nil
	end
end

function clsArenaItem:RefreshView(Uid)
	self._Uid = Uid
	network.SendPro("s_player_info", nil, Uid)
end

-------------------------------------------------------------------------------

clsArenaPanel = class("clsArenaPanel", clsCommonFrame)

function clsArenaPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_arena/arena_panel.lua", "竞技场")
	
	utils.RegButtonEvent(self:GetCompByName("btn_def_team"), function()
		
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_refresh"), function()
		self:RefreshOpponents()
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_shop"), function()
		ClsSystemMgr.GetInstance():EnterSystem("商店")
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_rank"), function()
		ClsSystemMgr.GetInstance():EnterSystem("排行榜", "竞技场排行榜")
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_history"), function()
		
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_score"), function()
		
	end)
	
	self:InitList()
	self:RefreshOpponents()
end

function clsArenaPanel:dtor()
	for _, wnd in pairs(self._ArenaItemList) do
		KE_SafeDelete(wnd)
	end
	self._ArenaItemList = nil
end

local pos_list = { -410, -205, 0, 205, 410 }
function clsArenaPanel:InitList()
	self._ArenaItemList = {}
	for i=1, 5 do
		local wnd = clsArenaItem.new(self:GetCompByName("rankarea"), i)
		table.insert(self._ArenaItemList, wnd)
		wnd:setPositionX(pos_list[i])
	end
end

function clsArenaPanel:RefreshOpponents()
	local UidList = {1000000002, 1000000003, 1000000004, 1000000005, 1000000006, 1000000007, 1000000008, 1000000009, 1000000010} 
	table.shuffle(UidList)
	
	--[[
	self:GetCompByName("rankarea"):runAction( cc.Sequence:create(
		cc.MoveTo:create(0.2, cc.p(512-600,275)),
		cc.CallFunc:create(function()
			self:GetCompByName("rankarea"):setPositionX(512+600)
		end),
		cc.MoveTo:create(0.2, cc.p(512,275))
	))
	]]--
	
	for i=1,5 do
		self._ArenaItemList[i]:RefreshView(UidList[i])
	end
end
