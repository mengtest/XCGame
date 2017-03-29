------------------
-- 好友界面
------------------
module("ui", package.seeall)

clsFriendPanel = class("clsFriendPanel", clsCommonFrame)

function clsFriendPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_friend/friend_panel.lua", "好友")
	
	local radioButtonGroup = ccui.RadioButtonGroup:create()
	self:addChild(radioButtonGroup)
	radioButtonGroup:addEventListener(function(radioButton, index, iType)
		if index == 0 then
			self:ShowFriendList()
		elseif index == 1 then
			self:ShowUserList()
		elseif index == 2 then
			self:ShowReqList()
		end
	end)
	for i = 1, 3 do radioButtonGroup:addRadioButton(self:GetCompByName("btn_chanel_"..i)) end
	
	radioButtonGroup:setSelectedButton(0)
end

function clsFriendPanel:dtor()
	local InstFriendMgr = KE_Director:GetFriendMgr()
	InstFriendMgr:DelListener(self)
end

function clsFriendPanel:InitFriendList()
	if self.mCompList then return self.mCompList end
	
	self.mCompList = clsCompList.new(self:GetCompByName("listwnd"), ccui.ScrollViewDir.vertical, 715, 410, 715, 124)
	local compList = self.mCompList
	compList:setPosition(12,15)
	compList:SetCellRefresher(function(CellComp, CellObj)
		local FriendInfo = CellObj:GetCellData()
		CellComp:GetCompByName("label_name"):setString(FriendInfo.Name)
		CellComp:GetCompByName("label_level"):setString( string.format("Lv.%d",FriendInfo.iGrade) )
		CellComp:GetCompByName("label_combatforce"):setString("战斗力："..FriendInfo.CombatForce)
		CellComp:GetCompByName("label_state"):setString(FriendInfo.IsOnLine==1 and "在线" or "离线")
		local head_wnd = clsHeadWnd.new(CellComp, setting.T_card_cfg[FriendInfo.TypeId].iHeadId, 2)
		head_wnd:setPosition(64,52)
	end)
	compList:SetCellCreator(function(CellObj)
		local btn = clsWindow.new(CellComp, "src/data/uiconfigs/ui_friend/friend_cell.lua")
		return btn
	end)
	compList:AddListener("lis_click_cell", "ec_click_cell", function(CellObj)
		local FriendInfo = CellObj:GetCellData()
		local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsUserInfoPanel")
		if wnd then wnd:Refresh(FriendInfo.Uid) end
	end)
	
	local InstFriendMgr = KE_Director:GetFriendMgr()
	InstFriendMgr:AddListener(self, "add_friend", function(Uid)
		local FriendInfo = InstFriendMgr:GetFriendInfo(Uid)
		compList:Insert(FriendInfo, Uid)
		compList:ForceReLayout()
	end)
	InstFriendMgr:AddListener(self, "del_friend", function(Uid)
		local idx = compList:GetCellIdxById(Uid)
		if idx then
			compList:Remove(idx)
			compList:ForceReLayout()
		end
	end)
	InstFriendMgr:AddListener(self, "update_friend", function(Uid)
		compList:UpdateCellDataById(Uid,InstFriendMgr:GetFriendInfo(Uid))
	end)
	
	return compList
end

function clsFriendPanel:ShowFriendList()
	local compList = self:InitFriendList()
	compList:RemoveAll()
	
	local InstFriendMgr = KE_Director:GetFriendMgr()
	local FriendList = InstFriendMgr:GetFriendList()
	for _, FriendInfo in ipairs(FriendList) do
		compList:Insert(FriendInfo, FriendInfo.Uid)
	end
	compList:ForceReLayout()
end

function clsFriendPanel:ShowUserList()
	local compList = self:InitFriendList()
	compList:RemoveAll()
	
	local InstFriendMgr = KE_Director:GetFriendMgr()
	local UserList = InstFriendMgr:GetUserList()
	for _, UserInfo in ipairs(UserList) do
		compList:Insert(UserInfo, UserInfo.Uid)
	end
	compList:ForceReLayout()
end

function clsFriendPanel:ShowReqList()
	local compList = self:InitFriendList()
	compList:RemoveAll()
	
	local InstFriendMgr = KE_Director:GetFriendMgr()
	local ReqList = InstFriendMgr:GetReqList()
	for _, ReqInfo in ipairs(ReqList) do
		compList:Insert(ReqInfo, ReqInfo.Uid)
	end
	compList:ForceReLayout()
end
