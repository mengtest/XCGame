-----------------
-- UI编辑器
-----------------
module("editorui", package.seeall)

clsUIEditPanel = class("clsUIEditPanel", ui.clsWindow)

function clsUIEditPanel:ctor(Parent)
	Parent = Parent or KE_Director:GetLayerMgr():GetLayer(const.LAYER_PANEL)
	ui.clsWindow.ctor(self,Parent)
	
	self.sCurCfgFile = nil		--当前编辑的文件
	self._CurOpCtrlName = nil	--当前操作的控件
	self._MultyOpList = {}
	self._AllAgents = {}		-- new_weak_table("v")
	
	self.mEditLayer = cc.Layer:create()		KE_SetParent(self.mEditLayer, self)
	self.mEventLayer = cc.Layer:create()	KE_SetParent(self.mEventLayer, self)
	self.mPopLayer = cc.Layer:create()		KE_SetParent(self.mPopLayer, self)
	
	self:InitEditLayer()
	self:InitWin32Event()
	self:InitTreeBarListener()
	self.mRootComp = self:AddNewCtrl("RootComp", "clsWindow", nil, nil)
    
    --每隔一分钟清理一次内存
    KE_SetAbsInterval(60,function()
    	KE_CleanupMemory()
    end)
end

function clsUIEditPanel:dtor()
	if self.mHighlightSpr then
		self.mHighlightSpr:release()
	end
	if self.mTreeBar then
		KE_SafeDelete(self.mTreeBar)
		self.mTreeBar = nil 
	end
	if self.mListControls then
		KE_SafeDelete(self.mListControls)
		self.mListControls = nil 
	end
end

function clsUIEditPanel:InitEditLayer()
	---------------
	-- 舞台
	---------------
	self.mWutaiView = cc.Scale9Sprite:create("res/mask_red.png")
	self.mEditLayer:addChild(self.mWutaiView)
	self.mWutaiView:setContentSize(GAME_CONFIG.VIEW_W,GAME_CONFIG.VIEW_H)
	self.mWutaiView:setPosition(400+GAME_CONFIG.VIEW_W/2+5,GAME_CONFIG.DESIGN_H/2)
	
	---------------
	-- 树形栏
	---------------
	self.mTreeBar = ui.clsCompTree.new(self.mEditLayer,400,GAME_CONFIG.DESIGN_H-55,"res/uiface/panels/list_common.png")
	self.mTreeBar:setPosition(2,5)
	
	---------------
	-- 快照栏
	---------------
	self.mQuickView = cc.Scale9Sprite:create("res/uiface/panels/list_common.png")
	self.mEditLayer:addChild(self.mQuickView)
	self.mQuickView:setContentSize(360,86)
	self.mQuickView:setPosition(400+GAME_CONFIG.VIEW_W+10+180, GAME_CONFIG.DESIGN_H-86/2-5)
	
	self.mLabelCtrlType = cc.Label:createWithTTF(const.DEF_FONT_CFG(), "")
	self.mLabelCtrlType:setAnchorPoint(cc.p(0,0.5))
	self.mLabelCtrlType:setPosition(5, 86*1/4)
	self.mQuickView:addChild(self.mLabelCtrlType)
	
	self.mEditCtrlName = ccui.EditBox:create(cc.size(230,40), "res/uiface/panels/edit_bg_4.png") 
	self.mEditCtrlName:setPosition(220, 86*3/4)
	self.mQuickView:addChild(self.mEditCtrlName)
	self.mEditCtrlName:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
	local function editboxEventHandler(eventType)
		if eventType == "return" then
			local NewName = self.mEditCtrlName:getText()
			
			if not self._CurOpCtrlName then
				self.mEditCtrlName:setText(self._CurOpCtrlName)
				utils.TellMe("请选择操作对象")
				return 
			end
			if self.mTreeBar:GetNode(self._CurOpCtrlName):GetPid() == nil then
				self.mEditCtrlName:setText(self._CurOpCtrlName)
				utils.TellMe("根节点不可重命名")
				return 
			end
			if not utils.IsValidVarName(NewName) then
				self.mEditCtrlName:setText(self._CurOpCtrlName)
				utils.TellMe("输入的控件名无效")
				return 
			end
			
			self.mTreeBar:ChgNodeId(self._CurOpCtrlName, NewName)
		end
	end
	self.mEditCtrlName:registerScriptEditBoxHandler(editboxEventHandler)
	local LabelDesc = cc.Label:createWithTTF(const.DEF_FONT_CFG(), "控件名：") 
	self.mEditCtrlName:addChild(LabelDesc)
	LabelDesc:setAnchorPoint(cc.p(1,0.5))
	LabelDesc:setPosition(-10, 20)
	
	---------------
	-- 属性栏
	---------------
	--通用属性初始化一次即可，特殊属性需要即时刷新
	self.mPropWnd = cc.Scale9Sprite:create("res/uiface/panels/list_common.png")
	self.mEditLayer:addChild(self.mPropWnd)
	self.mPropWnd:setContentSize(360,800)
	self.mPropWnd:setPosition(400+GAME_CONFIG.VIEW_W+10+180,800/2+5)
	
	self.mCommPropertyBar = cc.Node:create()
	self.mPropWnd:addChild(self.mCommPropertyBar)
	self.mCommPropertyBar:setPosition(360-200+100-4, 800-24)
	
	self.tCommPropItemList = {}
	local Parent = self.mCommPropertyBar
	for idx, info in ipairs(COMMON_ATTR) do
		local PropItem = ToolUtil.NewPropItem(info, Parent, 200, 40, function(PropName, ValueStr)
			self:UpdatePropData(PropName, ValueStr)
		end)
		self.tCommPropItemList[info.PropName] = PropItem
		PropItem:setPosition(0, -idx*42+42)
		PropItem.PropName = info.PropName
		PropItem.PropType = info.PropType
	end
	
	---------------
	-- 菜单栏
	---------------
	self.mMenuBar = cc.Node:create()
	self.mEditLayer:addChild(self.mMenuBar)
	self.mMenuBar:setPosition(5,GAME_CONFIG.DESIGN_H-25)
	
	local autoX = -60 
	local function NextX() autoX = autoX + 121 return autoX end
	local function NewMenuItem(TitleName, ClickFunc)
		local BtnMenu = ccui.Button:create("res/uiface/panels/list_common.png")
		KE_SetParent(BtnMenu,self.mMenuBar)
		BtnMenu:setScale9Enabled(true)
		BtnMenu:setContentSize(120,45)
		BtnMenu:setPosition(NextX(),0)
		BtnMenu:setTitleText(TitleName)
		utils.RegButtonEvent(BtnMenu, ClickFunc)
		return BtnMenu
	end
	
	NewMenuItem("打开", function() self:ShowLuaPanel() end)
	NewMenuItem("保存", function() self:SaveUIFile() end)
	NewMenuItem("预览", function() self:Preview() end) 
	autoX = autoX + 10 
	NewMenuItem("添加", function() 
		if not self._CurOpCtrlName then
			utils.TellMe("请选择父节点")
			return
		end
		self:ShowToolPanel() 
	end)
	NewMenuItem("水平对齐", function()
		self:HorizontalAlign()
	end)
	NewMenuItem("垂直对齐", function()
		self:VerticalAlign()
	end)
	NewMenuItem("水平等距", function()
		self:HorizontalEqualDis()
	end)
	NewMenuItem("垂直等距", function()
		self:VerticalEqualDis()
	end)
end

function clsUIEditPanel:ShowToolPanel()
	if self.mToolsBar then
		self.mToolsBar:Show(true)
		return
	end
	
	self.mToolsBar = ui.clsWindow.new()
	KE_SetParent(self.mToolsBar, self.mPopLayer)
	self.mToolsBar:SetToCenter()
	self.mToolsBar:SetModal(true,true,function() self.mToolsBar:Show(false) end)
	
	local ListHei = table.size(ALL_CONTROLS) * 50
	local compList = ui.clsCompList.new(self.mToolsBar, ccui.ScrollViewDir.vertical, 250, ListHei, 250, 50, "res/uiface/panels/list_common.png")
	compList:setPosition(-125,-320)
	compList:SetHighLightImgPath(nil)
	compList:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create("res/uiface/panels/list_common.png")
		btn:setScale9Enabled(true) 
		btn:setContentSize(250,48) 
		btn:setTitleText(CellObj:GetCellData())
		return btn
	end)
	compList:AddListener(self, "ec_click_cell", function(CellObj)
		local ParentCtrl = self._CurOpCtrlName
		if not ParentCtrl then 
			utils.TellMe("请选择父节点") 
			self.mToolsBar:Show(false)
			return 
		end
		
		local oTreeNode = self:AddNewCtrl(nil, CellObj:GetCellId(), nil, self._CurOpCtrlName)
		if oTreeNode then
			self:SetCurSelectCtrl(oTreeNode:GetId())
		end
		self.mToolsBar:Show(false)
	end)
	
	--
	for enname, cnname in pairs(ALL_CONTROLS) do
		compList:Insert(cnname,enname)
	end
	compList:ForceReLayout()
	
	self.mListControls = compList
end

function clsUIEditPanel:ShowLuaPanel()
	local wnd = ClsUIManager.GetInstance():ShowDialog("clsLuaPanel", function() 
		ClsUIManager.GetInstance():DestroyWindow("clsLuaPanel") 
	end)
	wnd:setPosition(GAME_CONFIG.DESIGN_W_2,GAME_CONFIG.DESIGN_H_2)
	wnd:_FixMaskPos()
	wnd:Reset("/src/data/uiconfigs", function(filename)
		self:OpenUIFile(filename)
	end)
end

---------------------------------------------

function clsUIEditPanel:InitTreeBarListener()
	self.mTreeBar:AddListener(self, "ec_select_changed", function(NodeId)
		self:OnSelectCtrlChg(NodeId)
	end)
	
	self.mTreeBar:AddListener(self, "ec_add_node", function(Id, oTreeNode)
		local Name = oTreeNode:GetId()
		local ParName = oTreeNode:GetPid()
		local ClassName = oTreeNode:GetData().ClassName
		local Attr = oTreeNode:GetData().Attr
		
		assert(not self._AllAgents[Name], "扑街了，怎么有同名Agenet: "..Name)
		local ParentAgent = self._AllAgents[ParName] or self.mWutaiView
		assert(ParentAgent, "父节点不存在")
		
		local AgentComp = helper.CreateCompnent(oTreeNode:GetData(), ParentAgent)
--		helper.ApplyCompnentAttr(AgentComp, ClassName, Attr)
		KE_SetParent(AgentComp, ParentAgent)
		self._AllAgents[Name] = AgentComp
		assert(self._AllAgents[Name], "扑街了，创建Agent失败")
		
		AgentComp.AgentBtn = ccui.Button:create("res/icons/frame/white_frame.png", "res/icons/frame/white_frame.png")
		local AgentBtn = AgentComp.AgentBtn
		AgentBtn:setScale9Enabled(true)
--		AgentBtn:setLocalZOrder(998)
		KE_SetParent(AgentBtn, AgentComp)
		self:FixAgentBtn(Name)
		AgentBtn:addTouchEventListener(function(sender, eventType)
			if eventType == ccui.TouchEventType.began then
				self:SetCurSelectCtrl(Name)
				self._CurMoveTarget = Name
			elseif eventType == ccui.TouchEventType.moved then

			elseif eventType == ccui.TouchEventType.ended then
				self._CurMoveTarget = nil
				if keyboard:IsKeyPressed(cc.KeyCode.KEY_CTRL) then
					self:AddMultyOp(Name)
				else 
					self:ClearMultyOp()
				end 
			end 
		end)
		
		if ParentAgent == self.mWutaiView then
			AgentComp:setPosition(GAME_CONFIG.VIEW_W/2,GAME_CONFIG.VIEW_H/2)
		end
	end)
	
	self.mTreeBar:AddListener(self, "ec_del_node", function(Id)
		local Name = Id
		assert(self._AllAgents[Name], "扑街了，怎么不存在Agenet: "..Name)
		KE_SafeDelete(self._AllAgents[Name])
		self._AllAgents[Name] = nil
--		self:SetCurSelectCtrl(nil)
		self:RemoveMultyOp(Name)
	end)
	
	self.mTreeBar:AddListener(self, "ec_chg_nodeid", function(Id, NewId)
		self._AllAgents[NewId] = self._AllAgents[Id]
		self._AllAgents[Id] = nil
	end)
end

-- 编辑属性数据
function clsUIEditPanel:UpdatePropData(PropName, ValueStr, CtrlName)
	CtrlName = CtrlName or self._CurOpCtrlName
	if not CtrlName then 
		utils.TellMe("请选择要操作的控件") 
		return 
	end
	
--	print("编辑属性数据", PropName, ValueStr)
	local vv 
	local oTreeNode = self.mTreeBar:GetNode(CtrlName)
	if COMMON_ATTR_FUNC[PropName] then
		vv = COMMON_ATTR_FUNC[PropName].Setter(CtrlName, oTreeNode, ValueStr)
	elseif SPEC_ATTR_FUNC[PropName] then
		vv = SPEC_ATTR_FUNC[PropName].Setter(CtrlName, oTreeNode, ValueStr)
	else 
		assert(false, "尚未定义该属性的Setter方法："..PropName)
	end
	
	-- 刷新视图
	local AgentComp = self._AllAgents[CtrlName]
	helper.ApplyCompnentAttr(AgentComp, oTreeNode:GetData().ClassName, {[PropName]=vv})
	self:FixFocusSpr()
	self:FixAgentBtn(CtrlName)
end

--刷新指定属性条
function clsUIEditPanel:RefreshUniqPropBar(PropName)
	local PropItem = self.tCommPropItemList[PropName] or self.tSpecPropItemList[PropName]
	
	if not self._CurOpCtrlName then 
		PropItem:setValueStr("")
		return 
	end
	
	local oTreeNode = self.mTreeBar:GetNode(self._CurOpCtrlName)
	local ValueStr = ""
	if COMMON_ATTR_FUNC[PropName] then
		ValueStr = COMMON_ATTR_FUNC[PropName].Getter(self._CurOpCtrlName, oTreeNode)
	elseif SPEC_ATTR_FUNC[PropName] then
		ValueStr = SPEC_ATTR_FUNC[PropName].Getter(self._CurOpCtrlName, oTreeNode)
	else 
		assert(false, "尚未定义该属性的Getter方法："..PropName)
	end
	PropItem:setValueStr(ValueStr or "")
--	print("刷新属性条", PropName, ValueStr)
end

-- 根据属性数据，刷新属性栏
function clsUIEditPanel:RefreshPropBar()
	for PropName, PropItem in pairs(self.tCommPropItemList) do
		self:RefreshUniqPropBar(PropName)
	end
	for PropName, PropItem in pairs(self.tSpecPropItemList) do
		self:RefreshUniqPropBar(PropName)
	end
end

function clsUIEditPanel:OnSelectCtrlChg(CtrlName)
	self._CurOpCtrlName = CtrlName
	self:ResetSpecPropBar()
	self:RefreshPropBar()
	self:FixFocusSpr()
	
	if CtrlName then
		self.mLabelCtrlType:setString("控件类型："..ALL_CONTROLS[self.mTreeBar:GetNode(CtrlName):GetData().ClassName])
		self.mEditCtrlName:setText(CtrlName)
	else
		self.mEditCtrlName:setText("")
		self.mLabelCtrlType:setString("控件类型：")
	end
end

function clsUIEditPanel:ResetSpecPropBar()
	self.tSpecPropItemList = {}
	
	if self.mSpecPropertyBar then
		KE_SafeDelete(self.mSpecPropertyBar)
		self.mSpecPropertyBar = nil
	end
	
	if not self._CurOpCtrlName then
		return 
	end
	
	local ClassName = self.mTreeBar:GetNode(self._CurOpCtrlName):GetData().ClassName
	local CurSpecAttrTbl = SPEC_ATTR[ClassName]
	if table.is_empty(CurSpecAttrTbl) then
		return 
	end
	
	self.mSpecPropertyBar = cc.Node:create()
	self.mPropWnd:addChild(self.mSpecPropertyBar)
	local x = self.mCommPropertyBar:getPositionX()
	local y = self.mCommPropertyBar:getPositionY()-table.size(self.tCommPropItemList)*42+30
	self.mSpecPropertyBar:setPosition(x, y)
	
	local Parent = self.mSpecPropertyBar
	for idx, info in ipairs(CurSpecAttrTbl) do
		local PropItem = ToolUtil.NewPropItem(info, Parent, 200, 40, function(PropName, ValueStr)
			self:UpdatePropData(PropName, ValueStr)
		end)
		self.tSpecPropItemList[info.PropName] = PropItem
		PropItem:setPosition(0, -idx*42)
		PropItem.PropName = info.PropName
		PropItem.PropType = info.PropType
	end
end

function clsUIEditPanel:FixFocusSpr()
	local CtrlName = self._CurOpCtrlName
	if not CtrlName then return end
	if not self.mFocusSpr then
		self.mFocusSpr = cc.Scale9Sprite:create("res/icons/frame/yellow_frame.png")
--		self.mFocusSpr:setLocalZOrder(999)
		self.mFocusSpr:retain()
	end
	if self._AllAgents[CtrlName] then
		KE_SetParent(self.mFocusSpr, self._AllAgents[CtrlName])
		local sz = self._AllAgents[CtrlName]:getContentSize()
		self.mFocusSpr:setContentSize(math.max(sz.width,MIN_AGENT_SIZE),math.max(sz.height,MIN_AGENT_SIZE))
		self.mFocusSpr:setPosition(sz.width/2,sz.height/2)
	end
end

function clsUIEditPanel:FixAgentBtn(CtrlName)
	local AgentComp = self._AllAgents[CtrlName]
	local AgentBtn = AgentComp.AgentBtn
	local sz = AgentComp:getContentSize()
	AgentBtn:setContentSize(math.max(sz.width,MIN_AGENT_SIZE),math.max(sz.height,MIN_AGENT_SIZE))
	AgentBtn:setPosition(sz.width/2,sz.height/2)
end

---------------------------------------------------

function clsUIEditPanel:GenSaveInfo(NodeName)
	NodeName = NodeName or "RootComp"
	local AllInfo = {}
	local SrcNode = self.mTreeBar:GetNode(NodeName)
	PreorderTraversal(SrcNode, function(CurNode, ParentNode, i)
		local info = {
			Name = CurNode:GetId(),
			ClassName = CurNode:GetData().ClassName,
			Attr = CurNode:GetData().Attr,
		}
		info.Childrens = info.Childrens or {}
		AllInfo[info.Name] = info
		
		local pInfo = AllInfo[CurNode:GetPid()]
		if pInfo then table.insert(pInfo.Childrens, info) end
	end)
	local RetInfo = AllInfo[NodeName]
--	table.print(RetInfo)
	return RetInfo
end

local NAME_INDEX = 0
function clsUIEditPanel:GenName()
	NAME_INDEX = NAME_INDEX + 1
	local Name = "Control_"..NAME_INDEX
	while self.mTreeBar:GetNode(Name) do
		NAME_INDEX = NAME_INDEX + 1
		Name = "Control_"..NAME_INDEX
	end
	return Name 
end

--------------------------------------------------------------

function clsUIEditPanel:SetCurSelectCtrl(CtrlName)
	self.mTreeBar:SetSelectedNode(CtrlName)
end

-- 添加新控件
function clsUIEditPanel:AddNewCtrl(Name, ClassName, Attr, ParName)
	assert(helper.IsValidControlType(ClassName), "ClassName无效")
	if Name == nil then
		Name = self:GenName()
	end
	
	if not utils.IsValidVarName(Name) then
		utils.TellMe("输入的控件名无效")
		return 
	end
	if self.mTreeBar:GetNode(Name) then
		utils.TellMe("控件名已经被占用："..Name)
		return 
	end
	
	local NodeData = {
		ClassName = ClassName,
		Attr = Attr or DEFAULT_ATTR[ClassName] or {},
	}
	local oTreeNode = self.mTreeBar:AddNode(Name, ParName, NodeData)
	print("添加控件：", Name, ClassName, ParName)
	
	return oTreeNode
end

-- 删除选中控件
function clsUIEditPanel:DelCtrl()
	local CtrlName = self._CurOpCtrlName
	if not CtrlName then 
		utils.TellMe("请选择要删除的控件") 
		return 
	end
	if CtrlName == "RootComp" then 
		utils.TellMe("根节点不可删除") 
		return 
	end
	
	self.mTreeBar:DelNode(CtrlName)
end

-- 取消多选
function clsUIEditPanel:RemoveMultyOp(CtrlName)
	for i, Name in ipairs(self._MultyOpList) do
		if Name == CtrlName then
			table.remove(self._MultyOpList, i)
			break 
		end
	end
	if self._AllAgents[CtrlName] then
		KE_SafeDelete(self._AllAgents[CtrlName].SprMultyMark)
		self._AllAgents[CtrlName].SprMultyMark = nil 
	end
end

-- 多选
function clsUIEditPanel:AddMultyOp(CtrlName)
	for i, Name in ipairs(self._MultyOpList) do
		if Name == CtrlName then
			return 
		end
	end
	table.insert(self._MultyOpList, CtrlName)
	local AgentComp = self._AllAgents[CtrlName]
	if not AgentComp.SprMultyMark then
		AgentComp.SprMultyMark = cc.Scale9Sprite:create("res/icons/frame/frame_choosed.png")
		KE_SetParent(AgentComp.SprMultyMark, AgentComp)
		local sz = AgentComp:getContentSize()
		AgentComp.SprMultyMark:setPosition(sz.width/2, sz.height/2)
		AgentComp.SprMultyMark:setContentSize(sz.width+4, sz.height+4)
	end
end

-- 退出多选
function clsUIEditPanel:ClearMultyOp()
	for _, CtrlName in pairs(self._MultyOpList) do
		KE_SafeDelete(self._AllAgents[CtrlName].SprMultyMark)
		self._AllAgents[CtrlName].SprMultyMark = nil 
	end 
	self._MultyOpList = {}
end

-- 水平对齐
function clsUIEditPanel:HorizontalAlign()
	if #self._MultyOpList < 2 then utils.TellMe("请选择操作对象",0.5) return end
	local y = self._AllAgents[ self._MultyOpList[1] ]:getPositionY()
	for i=2, #self._MultyOpList do
		self:UpdatePropData( "tPos", string.format("%f,%f",self._AllAgents[ self._MultyOpList[i] ]:getPositionX(),y), self._MultyOpList[i])
	end
	self:RefreshUniqPropBar("tPos")
end

-- 垂直对齐
function clsUIEditPanel:VerticalAlign()
	if #self._MultyOpList < 2 then utils.TellMe("请选择操作对象",0.5) return end
	local x = self._AllAgents[ self._MultyOpList[1] ]:getPositionX()
	for i=2, #self._MultyOpList do
		self:UpdatePropData( "tPos", string.format("%f,%f",x,self._AllAgents[ self._MultyOpList[i] ]:getPositionY()), self._MultyOpList[i])
	end
	self:RefreshUniqPropBar("tPos")
end

-- 水平等距
function clsUIEditPanel:HorizontalEqualDis()
	if #self._MultyOpList < 3 then utils.TellMe("请选择操作对象",0.5) return end
	local x1 = self._AllAgents[ self._MultyOpList[1] ]:getPositionX()
	local x2 = self._AllAgents[ self._MultyOpList[2] ]:getPositionX()
	local dis = math.abs(x1-x2) / (#self._MultyOpList-1)
	local from = math.min(x1,x2)
	for i=3, #self._MultyOpList do
		self:UpdatePropData( "tPos", string.format("%f,%f",from+dis*(i-2),self._AllAgents[ self._MultyOpList[i] ]:getPositionY()), self._MultyOpList[i])
	end
end

-- 垂直等距
function clsUIEditPanel:VerticalEqualDis()
	if #self._MultyOpList < 3 then utils.TellMe("请选择操作对象",0.5) return end
	local y1 = self._AllAgents[ self._MultyOpList[1] ]:getPositionY()
	local y2 = self._AllAgents[ self._MultyOpList[2] ]:getPositionY()
	local dis = math.abs(y1-y2) / (#self._MultyOpList-1)
	local from = math.min(y1,y2)
	for i=3, #self._MultyOpList do
		self:UpdatePropData( "tPos", string.format("%f,%f",self._AllAgents[ self._MultyOpList[i] ]:getPositionX(),from+dis*(i-2)), self._MultyOpList[i])
	end
end

-- 预览
function clsUIEditPanel:Preview()
	if self.mPreviewComp then
		KE_SafeDelete(self.mPreviewComp)
		self.mPreviewComp = nil
	end 
	self.mPreviewComp = ui.clsWindow.new(self.mPopLayer)
	local CfgInfo = self:GenSaveInfo()
	self.mPreviewComp:LoadByCfgInfo(self.mPreviewComp, CfgInfo)
	self.mPreviewComp:setPosition(GAME_CONFIG.DESIGN_W_2,GAME_CONFIG.DESIGN_H_2)
	self.mPreviewComp:SetModal(true,true,function() 
		KE_SetTimeout(1, function()
			KE_SafeDelete(self.mPreviewComp)
			self.mPreviewComp = nil
		end)
	end, "res/black.png")
end

-- 保存
function clsUIEditPanel:SaveUIFile()
	--备份
	if self.sCurCfgFile then
		local backup_path = "src/data/uiconfigs/ui_backup.lua"
		local backup_info = table.load(self.sCurCfgFile)
		if table.save(backup_info, backup_path) then
			print("备份成功", backup_path)
		else 
			print("备份失败")
		end
	end
	--保存
	local RetInfo = self:GenSaveInfo()
	if table.save(RetInfo, self.sCurCfgFile) then
		utils.TellMe("保存成功")
	else
		utils.TellMe("保存失败")
	end
end

-- 打开
function clsUIEditPanel:OpenUIFile(filepath)
	if not filepath or filepath == "" then return end
	local CfgInfo = table.load(filepath)
	if not CfgInfo then return end
	
	self.sCurCfgFile = filepath
	
	self.mTreeBar:DelAllNode()
	
	KE_SetTimeout(1,function()
		PreorderTraversal(CfgInfo, function(CurNode, ParentNode, i)
			local ParName = ParentNode and ParentNode.Name
			self:AddNewCtrl(CurNode.Name, CurNode.ClassName, CurNode.Attr, ParName)
		end)
	end)
end

-- 复制
function clsUIEditPanel:Copy(CtrlName)
	if not self.mTreeBar:GetNode(CtrlName) then
		utils.TellMe("无效的节点")
		return
	end
	
	self._PasteInfo = self:GenSaveInfo(CtrlName)
	return self._PasteInfo
end

-- 剪切
function clsUIEditPanel:Cut(CtrlName)
	if not self.mTreeBar:GetNode(CtrlName) then
		utils.TellMe("无效的节点")
		return
	end
	if CtrlName == "RootComp" then
		utils.TellMe("根节点不可删除")
		return 
	end
	
	self._PasteInfo = self:GenSaveInfo(CtrlName)
	self.mTreeBar:DelNode(CtrlName)
	return self._PasteInfo
end

-- 粘贴
function clsUIEditPanel:Paste(ParCtrlName)
	if not self._PasteInfo then return end
	if not self.mTreeBar:GetNode(ParCtrlName) then
		utils.TellMe("无效的父节点")
		return
	end
	
	PreorderTraversal(self._PasteInfo, function(CurNode, ParentNode, i)
		local ParName = ParentNode and ParentNode.Name or ParCtrlName
		local oTreeNode = self:AddNewCtrl(nil, CurNode.ClassName, table.clone(CurNode.Attr), ParName)
		CurNode.Name = oTreeNode:GetId()
	end)
end

-- 撤销
function clsUIEditPanel:Undo()
	
end

-- 重做
function clsUIEditPanel:Redo()
	
end

-----------------------------------------------------------------

function clsUIEditPanel:InitWin32Event()
	--键盘事件
	local function onKeyPressed(key_code, event)
		--复制
		if keyboard:IsTheseKeyPressed({cc.KeyCode.KEY_CTRL,cc.KeyCode.KEY_C}) then
			self:Copy(self._CurOpCtrlName)
		end
		--剪切
		if keyboard:IsTheseKeyPressed({cc.KeyCode.KEY_CTRL,cc.KeyCode.KEY_X}) then
			self:Cut(self._CurOpCtrlName)
		end
		--粘贴
		if keyboard:IsTheseKeyPressed({cc.KeyCode.KEY_CTRL,cc.KeyCode.KEY_V}) then
			self:Paste(self._CurOpCtrlName)
		end
		--撤销
		if keyboard:IsTheseKeyPressed({cc.KeyCode.KEY_CTRL,cc.KeyCode.KEY_Z}) then
			self:Undo()
		end
		--反撤销
		if keyboard:IsTheseKeyPressed({cc.KeyCode.KEY_CTRL,cc.KeyCode.KEY_Y}) then
			self:Redo()
		end
	end
	
	local function onKeyReleased(key_code, event)
		if key_code == cc.KeyCode.KEY_DELETE then
			self:DelCtrl()
		end
	end

	keyboard:AddKeyPressListener(onKeyPressed)
	keyboard:AddKeyReleaseListener(onKeyReleased)
	
	
	--鼠标事件
	local function onTouchBegan(touch, event)
		self._move_ctrl_flag = 0	--防止有时候只是想选择某控件，但是轻轻一点就移动了位置
        return true
    end
    local function onTouchMoved(touch, event)
    	self._move_ctrl_flag = self._move_ctrl_flag + 1
    	local Comp = self._CurMoveTarget and self._AllAgents[self._CurMoveTarget]
    	if Comp and self._move_ctrl_flag > 5 then
    		local ptTouch = touch:getDelta()
    		local curX,curY = Comp:getPosition()
    		local value = string.format("%f,%f", curX+ptTouch.x, curY+ptTouch.y)
    		self:UpdatePropData("tPos",value)
    		self:RefreshUniqPropBar("tPos")  --由于不是在编辑框输入的数字，这里需要实时刷新编辑框的值
    	end
    end
    local function onTouchEnded(touch, event)
    	if self._CurMoveTarget then
    		self:RefreshPropBar()
    	end
    end
	local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    self.mEventLayer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.mEventLayer)
end
