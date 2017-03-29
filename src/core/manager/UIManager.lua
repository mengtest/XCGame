--------------------
-- UI管理器
--------------------
ClsUIManager = class("ClsUIManager")
ClsUIManager.__is_singleton = true

function ClsUIManager:ctor()
	--
	self.tAllGUI = {}
	--
	self.mNoticeWnd = nil
	self.tNoticeLabelList = {}
	self.tmr_notice = nil
	--
	self.tAllTellMePanel = {}
end

function ClsUIManager:dtor()
	self:DestoryUILayer()
end

function ClsUIManager:InitUILayer(Parent)
	assert(Parent and not tolua.isnull(Parent), "无效的Parent")
	assert(not self.mUILayer, "重复创建UI层")
	self.mUILayer = clsUILayer.new(Parent)
end

function ClsUIManager:DestoryUILayer()
	self:DestroyAllWindow()
	
	if self.mUILayer then
		KE_SafeDelete(self.mUILayer)
		self.mUILayer = nil
	end
end

function ClsUIManager:DestroyAllWindow()
	-- 销毁公告栏
	if self.tmr_notice then
		KE_KillTimer(self.tmr_notice)
		self.tmr_notice = nil
	end
	self:DestroyNoticeWnd()
	
	-- 销毁TellMe
	for TellPanel, _ in pairs(self.tAllTellMePanel) do
		KE_SafeDelete(TellPanel)
	end
	self.tAllTellMePanel = {}
	
	-- 销毁窗口
	for cls_name, _ in pairs(self.tAllGUI) do
		self:DestroyWindow(cls_name)
	end
	self.tAllGUI = {}
end


------------------------
-- 
------------------------

-- 创建窗口
function ClsUIManager:CreateWindow(cls_name, iLayerId)
	assert(ui[cls_name], "未定义类："..cls_name)
	assert(iLayerId, "未知附加到哪个层"..iLayerId)
	local Parent = KE_Director:GetLayerMgr():GetLayer(iLayerId)
	local panel_cls = ui[cls_name]
	if not Parent or not panel_cls then return end
	
	if self.tAllGUI[cls_name] then
		KE_SetParent(self.tAllGUI[cls_name], Parent)
		return self.tAllGUI[cls_name]
	end
	
	print("创建界面", cls_name)
	self.tAllGUI[cls_name] = panel_cls.new(Parent)
	self.tAllGUI[cls_name]:AddScriptHandler(const.CORE_EVENT.cleanup, function()
		self.tAllGUI[cls_name] = nil
	end)
	
	return self.tAllGUI[cls_name]
end

-- 销毁窗口
function ClsUIManager:DestroyWindow(cls_name)
	assert(ui[cls_name], "未定义的类："..cls_name)
	if self.tAllGUI[cls_name] then
		KE_SafeDelete(self.tAllGUI[cls_name])
		self.tAllGUI[cls_name] = nil
		print("销毁界面", cls_name)
	end
end

-- 销毁窗口
function ClsUIManager:DestroyWindowEx(Wnd)
	local cls_name = self:GetKeyOfWindow(Wnd)
	if cls_name then
		self:DestroyWindow(cls_name)
	end
end

-- 隐藏窗口
function ClsUIManager:HideWindow(cls_name)
	assert(ui[cls_name], "未定义的类："..cls_name)
	if self.tAllGUI[cls_name] then
		self.tAllGUI[cls_name]:Show(false)
	end
end

-- 获取窗口
function ClsUIManager:GetWindow(cls_name)
	assert(ui[cls_name], "未定义的类："..cls_name)
	return self.tAllGUI[cls_name]
end

function ClsUIManager:GetKeyOfWindow(Wnd)
	if not Wnd then return nil end
	for cls_name, WndObj in pairs(self.tAllGUI) do 
		if WndObj == Wnd then
			return cls_name
		end
	end
	return nil 
end

function ClsUIManager:DumpDebugInfo()
	print("窗口总数量", table.size(self.tAllGUI))
	for cls_name, wnd in pairs(self.tAllGUI) do
		print(cls_name, wnd)
	end
end

------------------------
-- 
------------------------

-- 显示一级窗口（同一时刻只显示一个面板）
function ClsUIManager:ShowPanel(cls_name, is_cache)
	local OldKey = self.sShowingPanel
	if OldKey and OldKey ~= cls_name then
		if is_cache then
			self:HideWindow(OldKey)
		else
			self:DestroyWindow(OldKey)
		end
	end
	
	local Wnd = self:CreateWindow(cls_name, const.LAYER_PANEL)
	if not Wnd then return end
	self.sShowingPanel = cls_name
	Wnd:Show(true)
	return Wnd
end

-- 显示二级弹窗
function ClsUIManager:ShowPopWnd(cls_name)
	local Wnd = self:CreateWindow(cls_name, const.LAYER_POP)
	if not Wnd then return end
	Wnd:SetModal(true, true)
	Wnd:Show(true)
	return Wnd
end

-- 显示模态对话框
function ClsUIManager:ShowDialog(cls_name, OnClickMask)
	local Wnd = self:CreateWindow(cls_name, const.LAYER_DLG)
	if not Wnd then return end
	Wnd:SetModal(true, true, OnClickMask)
	Wnd:Show(true)
	return Wnd
end

-- 显示Tips
function ClsUIManager:ShowTips(cls_name, bShowMask, OnClickMask)
	local Wnd = self:CreateWindow(cls_name, const.LAYER_TIPS)
	if not Wnd then return end
	Wnd:SetModal(true, bShowMask, OnClickMask)
	Wnd:Show(true)
	Wnd:PlayPopAni()
	return Wnd
end



-- 公告条
local BKG_WIDTH = 720
local BKG_HEIGHT = 40
local BKG_WIDTH_2 = 360
local BKG_HEIGHT_2 = 20
function ClsUIManager:DestroyNoticeWnd()
	for _, LabelNotice in pairs(self.tNoticeLabelList) do
		KE_SafeDelete(LabelNotice)
	end
	self.tNoticeLabelList = {}
	
	if self.mNoticeWnd then
		KE_SafeDelete(self.mNoticeWnd)
		self.mNoticeWnd = nil
	end
end
function ClsUIManager:CreateNoticeWnd()
	if self.mNoticeWnd then return self.mNoticeWnd end
	local tipslayer = KE_Director:GetLayerMgr():GetLayer(const.LAYER_TIPS)
	if not tipslayer then return nil end
	
	self.mNoticeWnd = cc.Scale9Sprite:create("res/transparent.png")
	KE_SetParent(self.mNoticeWnd, tipslayer)
	self.mNoticeWnd:setPreferredSize(cc.size(BKG_WIDTH, BKG_HEIGHT))
	self.mNoticeWnd:setPosition(GAME_CONFIG.DESIGN_W/2, GAME_CONFIG.DESIGN_H-70)
	
	self.mNoticeWnd.mClipWnd = ccui.Layout:create() 
	KE_SetParent(self.mNoticeWnd.mClipWnd, self.mNoticeWnd)
	self.mNoticeWnd.mClipWnd:setClippingEnabled(true)
	self.mNoticeWnd.mClipWnd:setContentSize(cc.size(BKG_WIDTH, BKG_HEIGHT))
	self.mNoticeWnd.mClipWnd:setPosition(0,0)
end
function ClsUIManager:TellNotice(sNotice)
	if not sNotice or utils.IsWhiteSpace(sNotice) then return end
	self.tNoticeStrList = self.tNoticeStrList or {}
	
	if #self.tNoticeStrList <= 500 then 
		--限制公告数量。由于每条大约存留7秒多 500条足够显示两小时！
		table.insert(self.tNoticeStrList, sNotice)
	end
	
	self:CreateNoticeWnd()
	if not self.mNoticeWnd then return end
	assert( not tolua.isnull(self.mNoticeWnd), "公告板不是有效的C指针" )
	
	self.tmr_notice = self.tmr_notice or KE_SetInterval(2, function()
		if #self.tNoticeStrList <= 0 then 
			KE_KillTimer(self.tmr_notice)
			self.tmr_notice = nil
		end
		
		local LastLabel = self.tNoticeLabelList[#self.tNoticeLabelList]
		local CanAdd = (not LastLabel) or (30 + LastLabel:getPositionX() + LastLabel:getContentSize().width <= BKG_WIDTH)
		
		if CanAdd and #self.tNoticeStrList > 0 then
			local LabelNotice = cc.Label:createWithTTF(const.DEF_FONT_CFG(), self.tNoticeStrList[1])
			KE_SetParent(LabelNotice, self.mNoticeWnd.mClipWnd)
			LabelNotice:setAnchorPoint(cc.p(0,0.5))
			table.insert(self.tNoticeLabelList, LabelNotice)
			table.remove(self.tNoticeStrList, 1)
			
			LabelNotice:setPosition(BKG_WIDTH,BKG_HEIGHT_2)
			local UseTime = (LabelNotice:getContentSize().width+BKG_WIDTH) / 64 
			LabelNotice:runAction(cc.Sequence:create(
				cc.MoveTo:create(UseTime, cc.p(-LabelNotice:getContentSize().width, BKG_HEIGHT_2)),
				cc.CallFunc:create(function()
					KE_SafeDelete(self.tNoticeLabelList[1])
					table.remove(self.tNoticeLabelList, 1)
					if #self.tNoticeLabelList == 0 then
						self:DestroyNoticeWnd()
					end
				end)
			))
		end
	end)
end

-- 显示通知消息
function ClsUIManager:TellMe(Txt, DelayTime)
	if not Txt or utils.IsWhiteSpace(Txt) then return end
	local Parent = KE_Director:GetLayerMgr():GetLayer(const.LAYER_TIPS)
	if not Parent then return end
	
	-- 弹出位置
	local PosX, BeginY = GAME_CONFIG.DESIGN_W_2, GAME_CONFIG.DESIGN_H_2-40
	
	-- 创建控件
	local TellPanel = cc.Node:create()
	KE_SetParent(TellPanel, Parent)
	local BkgTell = cc.Scale9Sprite:create("res/uiface/panels/tellme.png")
	BkgTell:setPreferredSize(cc.size(300, 40))
	KE_SetParent(BkgTell, TellPanel)
	local LabelTell = cc.Label:createWithTTF(const.DEF_FONT_CFG(), Txt)
	KE_SetParent(LabelTell, TellPanel)
	TellPanel:setPosition(PosX,BeginY)
	self.tAllTellMePanel[TellPanel] = true
	
	-- 调整位置
	local AllTellMePanel = self.tAllTellMePanel
	for Pnl, _ in pairs(AllTellMePanel) do
		Pnl:setPosition(PosX, Pnl:getPositionY()+40)
	end
	
	-- 定时销毁
	TellPanel:runAction(cc.Sequence:create(
		cc.DelayTime:create(DelayTime or 2),
		cc.CallFunc:create(function ()
			KE_SafeDelete(TellPanel)
			self.tAllTellMePanel[TellPanel] = nil
		end)
	))
end

-- 弹幕
local font_cfg = const.DEF_FONT_CFG()
function ClsUIManager:TellBarrage(sCont)
	if not sCont or utils.IsWhiteSpace(sCont) then return end 
	local Parent = KE_Director:GetLayerMgr():GetLayer(const.LAYER_TIPS)
	if not Parent then return end
	
	local LabelBarrage = cc.Label:createWithTTF(font_cfg, sCont)
	KE_SetParent(LabelBarrage, Parent)
	LabelBarrage:setAnchorPoint(cc.p(0,0.5))
	local y = math.random(200,GAME_CONFIG.SCREEN_H-80)
	LabelBarrage:setPosition(GAME_CONFIG.SCREEN_W,y)
	local UseTime = (LabelBarrage:getContentSize().width+GAME_CONFIG.SCREEN_W) / 128 
	LabelBarrage:runAction(cc.MoveTo:create(UseTime, cc.p(-LabelBarrage:getContentSize().width, y)))
end
