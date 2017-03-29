-------------------
-- 宣传推荐窗口
-------------------
module("ui", package.seeall)

clsAdvertisePanel = class("clsAdvertisePanel", clsWindow)

function clsAdvertisePanel:ctor(parent)
	clsWindow.ctor(self, parent)
	self:SetToCenter()
end

function clsAdvertisePanel:dtor()
	
end

function clsAdvertisePanel:SetAdverInfo(AdverInfo, AdverType)
	-- 海报图
	self.mSprPoster = cc.Sprite:create(AdverInfo.ImgPath)
	KE_SetParent(self.mSprPoster, self)
	
	local SizePoster = self.mSprPoster:getContentSize()
	local fontcfg = const.DEF_FONT_CFG()
	
	-- 条件宣传才有点击事件
	if AdverType==2 and AdverInfo.click_func then
		self.mBtnEnter = ccui.Button:create() 
		KE_SetParent(self.mBtnEnter, self)
		self.mBtnEnter:setScale9Enabled(true) 
		self.mBtnEnter:setContentSize(SizePoster)
		utils.RegButtonEvent(self.mBtnEnter, function()
			AdverInfo.click_func()
			procedure.ClsProcedureMgr.GetInstance():StopCurProcedure()
		end)
	end
	
	-- 外框
	self.mSprFrame = cc.Scale9Sprite:create("res/uiface/panels/stage_panel.png")
	KE_SetParent(self.mSprFrame, self)
	self.mSprFrame:setLocalZOrder(-1)
	self.mSprFrame:setContentSize(SizePoster.width+12, SizePoster.height+16)
	
	-- 标题
	if AdverInfo.TitleStr and AdverInfo.TitleStr ~= "" then
		fontcfg.fontSize = 32
		self.mLabelTitle = cc.Label:createWithTTF(fontcfg, AdverInfo.TitleStr) 
		KE_SetParent(self.mLabelTitle, self)
		self.mLabelTitle:setPositionY(SizePoster.height/2+20)
	end
	
	-- 时间
	if AdverInfo.TimeStr then
		local time_str = AdverInfo.TimeStr
		if type(AdverInfo.TimeStr)=="function" then
			time_str = AdverInfo.TimeStr()
		end
		
		if time_str and time_str ~= "" then
			fontcfg.fontSize = 28
			self.mLabelTime = cc.Label:createWithTTF(fontcfg, time_str) 
			KE_SetParent(self.mLabelTime, self)
			self.mLabelTime:setPositionY(-SizePoster.height/2-32)
		end
	end
end
