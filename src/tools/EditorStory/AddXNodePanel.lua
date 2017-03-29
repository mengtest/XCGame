------------------
-- 节点创建面板
------------------
module("editorstory", package.seeall)

clsAddXNodePanel = class("clsAddXNodePanel", ui.clsWindow)

function clsAddXNodePanel:ctor(parent)
	ui.clsWindow.ctor(self, parent)
	self.cmdName = nil 
	self.Pid = nil 
	self._FuncOnBtnSure = nil
	self._FuncOnBtnCancel = nil
	
	self:InitAll()
end

function clsAddXNodePanel:dtor()
	if self.mListWnd then
		KE_SafeDelete(self.mListWnd)
		self.mListWnd = nil 
	end
end

function clsAddXNodePanel:Reset(Pid, OnBtnSure, OnBtnCancel)
	self.Pid = Pid
	self._FuncOnBtnSure = OnBtnSure
	self._FuncOnBtnCancel = OnBtnCancel
end

function clsAddXNodePanel:InitAll()
	--
	local CMD_TABLE = actree:GetCmdTable()
	local LIST_WID, LIST_HEI = 320, GAME_CONFIG.DESIGN_H-60
	local CELL_WID, CELL_HEI = 320, 50
	
	--------------
	---
	--------------
	self.mListWnd = ui.clsCompList.new(self, ccui.ScrollViewDir.vertical, LIST_WID, LIST_HEI, CELL_WID, CELL_HEI)
	self.mListWnd:setPosition(-GAME_CONFIG.DESIGN_W_2+5,-GAME_CONFIG.DESIGN_H_2+5)
	self.mListWnd:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create("res/uiface/buttons/btn_blue.png", "res/uiface/buttons/btn_green.png")
		btn:setScale9Enabled(true) 
		btn:setContentSize(CELL_WID,CELL_HEI) 
		btn:setTitleText(CellObj:GetCellId())
		return btn
	end)
	self.mListWnd:AddListener(self, "ec_click_cell", function(CellObj)
		local cmdName = CellObj:GetCellId()
		self.cmdName = cmdName
		self.mCommAttrEditorList["cmdName"].EditorValue:setText(cmdName)
	end)
	
	--
	local ListWnd = self.mListWnd
	for cmd_name, cls_name in pairs(CMD_TABLE) do
		ListWnd:Insert(cmd_name, cmd_name)
	end
	self.mListWnd:ForceReLayout()
	
	--------------
	---
	--------------
	self.m_LuaFilter = ccui.EditBox:create(cc.size(CELL_WID,40), "res/uiface/panels/edit_bg_4.png") 
	KE_SetParent(self.m_LuaFilter, self)
	self.m_LuaFilter:setPosition(-GAME_CONFIG.DESIGN_W_2+5+CELL_WID/2,GAME_CONFIG.DESIGN_H_2-25)
	local function editboxEventHandler(eventType)
		if eventType == "return" then
			self.mListWnd:RemoveAll()
			local string_find = string.find
			local string_lower = string.lower
			local ListWnd = self.mListWnd
			local filterStr = string_lower(self.m_LuaFilter:getText())
			for cmd_name, cls_name in pairs(CMD_TABLE) do
				print( string_lower(cmd_name), filterStr )
				if string_find(string_lower(cmd_name), filterStr) then
					ListWnd:Insert(cmd_name, cmd_name)
				end
			end
			self.mListWnd:ForceReLayout()
		end
	end
	self.m_LuaFilter:registerScriptEditBoxHandler(editboxEventHandler)
	
	--------------
	---
	--------------
	self.mPropertyBar, self.mCommAttrEditorList = ToolUtil.NewCommPropBar(COMMON_ATTR, self)
	self.mPropertyBar:setPosition(-180,80)
	
	--------------
	---
	--------------
	local BtnSure = ccui.Button:create("res/uiface/buttons/btn_blue.png")
	local BtnCancel = ccui.Button:create("res/uiface/buttons/btn_blue.png")
	BtnSure:setTitleText("确定")
	BtnCancel:setTitleText("取消")
	KE_SetParent(BtnSure, self)
	KE_SetParent(BtnCancel, self)
	BtnSure:setPosition(-80,-120)
	BtnCancel:setPosition(80, -120)
	
	utils.RegButtonEvent(BtnSure, function()
		local Id = self.mCommAttrEditorList["Id"].EditorValue:getText()
		local evtname = self.mCommAttrEditorList["evtname"].EditorValue:getText()
		local cmdName = self.cmdName
		local Pid = self.Pid
		
		evtname = tonumber(evtname)
		if evtname == 0 then evtname = actree.XEventEnum.ec_xstart end
		if evtname == -1 then evtname = actree.XEventEnum.ec_xfinish end
		
		if self._FuncOnBtnSure then
			self._FuncOnBtnSure(Id, cmdName, Pid, evtname)
		end
	end)
	
	utils.RegButtonEvent(BtnCancel, function()
		if self._FuncOnBtnCancel then
			self._FuncOnBtnCancel()
		end
		self:Show(false)
	end)
end
