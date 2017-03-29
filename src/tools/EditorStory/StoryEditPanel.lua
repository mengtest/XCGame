-----------------
-- 剧情编辑面板
-----------------
module("editorstory", package.seeall)

clsStoryEditPanel = class("clsStoryEditPanel", ui.clsWindow)

function clsStoryEditPanel:ctor(parent)
	parent = parent or KE_Director:GetLayerMgr():GetLayer(const.LAYER_PANEL)
	assert(parent and not tolua.isnull(parent))
	ui.clsWindow.ctor(self, parent)
	self:setLocalZOrder(99)
	
	self.mCurCfgFile = nil
	self.mCurSelectCtrl = nil
	
	self.mWutaiLayer = cc.Layer:create()	KE_SetParent(self.mWutaiLayer, self)
	self.mEditLayer = cc.Layer:create()		KE_SetParent(self.mEditLayer, self)
	self.mEventLayer = cc.Layer:create()	KE_SetParent(self.mEventLayer, self)
	self.mPopLayer = cc.Layer:create()		KE_SetParent(self.mPopLayer, self)
	
	self:InitEditLayer()
	self:InitWutaiLayer()
	self:InitKeyBoardListener()
end

function clsStoryEditPanel:dtor()
	if self.mTreeBar then
		KE_SafeDelete(self.mTreeBar)
		self.mTreeBar = nil 
	end
	if self.mLuaPanel then
		KE_SafeDelete(self.mLuaPanel)
		self.mLuaPanel = nil 
	end
end

function clsStoryEditPanel:AddNewXUnit(Id, cmdName, Pid, evtname, args)
	local CMD_TABLE = actree.GetCmdTable()
	
	if not Id then
		utils.TellMe("必须节点ID")
		return 
	end
	if is_string(Id) and (utils.IsWhiteSpace(Id) or string.gsub(Id, "[_%w][_%w]*", "") ~= "") then
		utils.TellMe("输入的节点ID无效")
		return 
	end
	if self.mTreeBar:GetNode(Id) then
		utils.TellMe("ID已经被占用："..Id)
		return 
	end
	if Pid == nil and cmdName ~= "x_root_node" then 
		utils.TellMe("必须设置父节点")
		return 
	end
	if cmdName ~= "x_root_node" and not self.mTreeBar:GetNode(Pid) then
		utils.TellMe("父节点不存在："..Pid)
		return 
	end
	if not CMD_TABLE[cmdName] then
		utils.TellMe("无效的命令")
		return 
	end
	if cmdName ~= "x_root_node" and not actree.IsValidXNodeEvtName(evtname) then
		utils.TellMe("无效的触发点: "..(evtname or "nil"))
		return 
	end
	if cmdName == "x_root_node" and not self.mTreeBar:IsEmpty() then
		utils.TellMe("只能存在一个根节点"..cmdName)
		return 
	end
	
	--
	if cmdName == "x_root_node" then 
		self._RootId = Id 
	end
	
	args = args or table.clone( CMD_TABLE[cmdName]._default_args )
	
	print("创建节点", Id, cmdName, Pid, evtname)
	local NodeData = {
		["Id"] = Id,
		["cmdName"] = cmdName,
		["Pid"] = Pid,
		["evtname"] = evtname,
		["args"] = args,
	}
	self.mTreeBar:AddNode(Id, NodeData, Pid)
	
	return Id
end

function clsStoryEditPanel:DelXUnit()
	local SelectId = self.mTreeBar:GetSelectedNode()
	if SelectId == nil then 
		utils.TellMe("请选择要删除的节点")
		return 
	end
	
	self.mTreeBar:DelNode(SelectId)
end

function clsStoryEditPanel:RefreshCommPropBar()
	local SelectId = self.mTreeBar:GetSelectedNode()
	local NodeInfo = self.mTreeBar:GetNode(SelectId)
	if not NodeInfo then return end
	local NodeData = NodeInfo._Data
	
	for k, v in pairs(NodeData) do
		if self.mCommAttrEditorList[k] then
			self.mCommAttrEditorList[k].EditorValue:setText(v)
		end
	end
end

function clsStoryEditPanel:RefreshSpecPropBar()
	KE_SafeDelete(self.mSpecPropertyBar)
	self.mSpecPropertyBar = nil
	
	local SelectId = self.mTreeBar:GetSelectedNode()
	local NodeInfo = self.mTreeBar:GetNode(SelectId)
	if not NodeInfo then return end
	local NodeData = NodeInfo._Data
	
	local cmdName = NodeData.cmdName
	local CMD_TABLE = actree:GetCmdTable()
	local default_clone = table.clone( CMD_TABLE[cmdName]._default_args )
	table.copy(default_clone, NodeData.args)
	
	local NodeSpec = cc.Node:create()
	KE_SetParent(NodeSpec, self.mPropertyBar)
	NodeSpec:setPosition(0, -45*table.size(self.mCommAttrEditorList)-6)
	self.mSpecPropertyBar = NodeSpec
	
	local Cnt = 0
	local level = 0
	local function walk_table(t)
		level = level + 1
		local k, v
		for k, v in pairs(t) do
			Cnt = Cnt + 1
			
			local NodeAttr = cc.Node:create()
			NodeSpec:addChild(NodeAttr)
			NodeAttr:setPosition(0, -45*Cnt)
			local LabelKey = cc.Label:createWithTTF(const.DEF_FONT_CFG(), k) 
			NodeAttr:addChild(LabelKey)
			LabelKey:setAnchorPoint(cc.p(0,0.5))

			if type(v) == "table" then
				walk_table(v)
			else
				local EditorValue = ccui.EditBox:create(cc.size(250,40), "res/uiface/panels/edit_bg_4.png") 
				NodeAttr:addChild(EditorValue)
				EditorValue:setAnchorPoint(cc.p(0,0.5))
				EditorValue:setPositionX(90)
				EditorValue:setText(v)
			end
		end
		level = level - 1
	end
	 
	walk_table(default_clone)
end

function clsStoryEditPanel:InitWutaiLayer()
	self.mTreeBar = ui.clsCompTree.new(self.mWutaiLayer,GAME_CONFIG.DESIGN_W-400,GAME_CONFIG.DESIGN_H-80,"res/mask_red.png")
	self.mTreeBar:setPosition(5,5)
	self.mTreeBar.GenTextContent = function(this, NodeInfo) 
		local NodeData = NodeInfo._Data
		if NodeData.evtname then
			return "["..NodeData.evtname.."]  " .. NodeData.Id..":  " .. NodeData.cmdName
		else
			return NodeData.Id..":  " .. NodeData.cmdName
		end
	end
	self.mTreeBar:AddListener(self, "ec_select_changed", function(NodeId)
		self:RefreshCommPropBar()
		self:RefreshSpecPropBar()
	end)
	
	self:AddNewXUnit("root", "x_root_node")
end

function clsStoryEditPanel:InitEditLayer()
	local CMD_TABLE = actree:GetCmdTable()
	local RIGHT_WID = 350
	
	---------------
	-- 属性栏
	---------------
	--通用属性初始化一次即可，特殊属性需要即时刷新
	self.mPropertyBar, self.mCommAttrEditorList = ToolUtil.NewCommPropBar(COMMON_ATTR, self.mEditLayer)
	self.mPropertyBar:setPosition(GAME_CONFIG.DESIGN_W-RIGHT_WID-5,GAME_CONFIG.DESIGN_H-10)
	
	---------------
	-- 菜单栏
	---------------
	self.mMenuBar = cc.Node:create()
	self.mEditLayer:addChild(self.mMenuBar)
	self.mMenuBar:setPosition(0,GAME_CONFIG.DESIGN_H-35)
	
	local autoX = -20
	local function NextX() autoX = autoX + 100 return autoX end
	local function NewMenuItem(TitleName, ClickFunc)
		local BtnMenu = ccui.Button:create("res/uiface/buttons/btn_blue.png")
		KE_SetParent(BtnMenu,self.mMenuBar)
		BtnMenu:setPosition(NextX(),0)
		BtnMenu:setTitleText(TitleName)
		utils.RegButtonEvent(BtnMenu, ClickFunc)
		return BtnMenu
	end
	
	NewMenuItem("打开", function() self:ToggleLuaPanel() end)
	NewMenuItem("保存", function() self:SaveFile() end)
	NewMenuItem("预览", function()
		local StoryInfo = self:GenSaveInfo()
		if StoryInfo and not table.is_empty(StoryInfo) then
			ClsStoryPlayer.GetInstance():PlayInfo(StoryInfo, function() end)
		end
	end)
	NewMenuItem("添加", function()
		local Pid = self.mTreeBar:GetSelectedNode()
		if not Pid and cmdName ~= "x_root_node" then
			utils.TellMe("请选择父节点")
			return 
		end
		
		if not self.mAddWnd then
			self.mAddWnd = clsAddXNodePanel.new(self.mPopLayer)
			self.mAddWnd:setPosition(GAME_CONFIG.DESIGN_W/2, GAME_CONFIG.DESIGN_H/2)
			self.mAddWnd:SetModal(true,true,nil,"res/black.png")
		end
		self.mAddWnd:Show(true)
		self.mAddWnd:Reset(Pid, function(Id, cmdName, Pid, evtname)
			if self:AddNewXUnit(Id, cmdName, Pid, evtname) then
				self.mAddWnd:Show(false)
				self.mTreeBar:SetSelectedNode(Id)
			end
		end)
	end)
end

function clsStoryEditPanel:ToggleLuaPanel()
	self.mLuaPanel = self.mLuaPanel or ToolUtil.clsLuaPanel.new(self.mPopLayer)
	self.mLuaPanel:Show(true)
	self.mLuaPanel:setPosition(GAME_CONFIG.DESIGN_W_2,GAME_CONFIG.DESIGN_H_2)
	self.mLuaPanel:SetModal(true,true,function() self.mLuaPanel:Show(false) end, "res/black.png")
	
	self.mLuaPanel:Reset("/src/data/storys", function(filename)
		self:OpenFile(filename)
	end)
end

function clsStoryEditPanel:InitKeyBoardListener()
	--键盘事件
	local function onKeyPressed(key_code, event)
		if key_code == cc.KeyCode.KEY_LEFT_ARROW then
			
		elseif key_code == cc.KeyCode.KEY_RIGHT_ARROW then
			
		elseif key_code == cc.KeyCode.KEY_UP_ARROW then
			
		elseif key_code == cc.KeyCode.KEY_DOWN_ARROW then
			
		end
	end
	
	local function onKeyReleased(key_code, event)
		if key_code == cc.KeyCode.KEY_DELETE then
			self:DelXUnit()
		end
	end

	keyboard:AddKeyPressListener(onKeyPressed)
	keyboard:AddKeyReleaseListener(onKeyReleased)
	
	
	--鼠标事件
	local function onTouchBegan(touch, event)
        return true
    end
    local function onTouchMoved(touch, event)
    	
    end
    local function onTouchEnded(touch, event)
    	
    end
	local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self.mEventLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.mEventLayer)
end

function clsStoryEditPanel:GenSaveInfo()
	if not self._RootId then return nil end
	
	local AllInfo = {}
	
	PreorderTraversal(self.mTreeBar:GetNode(self._RootId), function(CurNode, ParentNode, i)
		local NodeData = CurNode._Data
		AllInfo[NodeData.Id] = AllInfo[NodeData.Id] or {
	        ["args"] = table.clone(NodeData.args),
	        ["cmdName"] = NodeData.cmdName,
	        ["connectors"] = {
	            ["ec_xfinish"] = { },
	            ["ec_xstart"] = { },
	        },
	    }
	    local info = AllInfo[NodeData.Id]
		
		local pInfo = AllInfo[CurNode._Pid]
		if pInfo then 
			pInfo.connectors[NodeData.evtname] = pInfo.connectors[NodeData.evtname] or {}
			table.insert(pInfo.connectors[NodeData.evtname], NodeData.Id)
		end
	end)
	
	return AllInfo
end

function clsStoryEditPanel:SaveFile()
	local RetInfo = self:GenSaveInfo()
	if RetInfo and not table.is_empty(RetInfo) then
		table.save(RetInfo, "src/data/storys/story_test.lua")
		utils.TellMe("保存成功")
	else 
		utils.TellMe("保存失败")
	end
end

function clsStoryEditPanel:OpenFile(filepath)
	if not filepath or filepath == "" then return end
	local info_list = table.load(filepath)
	if not info_list then return end
	
	--
	self.mTreeBar:DelAllNode()
	self._RootId = nil
	
	--
	self.mCurCfgFile = filepath
	print("OpenFile", filepath)
	
	local root_info
	local root_id
	for idx, xInfo in pairs(info_list) do
		if xInfo.cmdName == "x_root_node" then
			root_info = xInfo
			root_id = idx
			break
		end
	end
	
	local function BuildXInfo(xInfo, Id, Pid, evtname)
		self:AddNewXUnit(Id, xInfo.cmdName, Pid, evtname, xInfo.args)
		
		for evtName, childList in pairs(xInfo.connectors) do
			for _, childIdx in ipairs(childList) do
				assert(info_list[Id], string.format("节点不存在："..Id))
				assert(info_list[childIdx], string.format("节点不存在："..childIdx))
				BuildXInfo(info_list[childIdx], childIdx, Id, evtName)
			end
		end
	end
	BuildXInfo(root_info,root_id)
end
