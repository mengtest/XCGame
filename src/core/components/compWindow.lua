--------------------
-- 窗口基类
--------------------
module("ui", package.seeall)

clsWindow = class("clsWindow", clsImageView, helper.clsCompLoader, clsCoreObject)

clsWindow:RegisterEventType(const.CORE_EVENT.EC_SHOW)

function clsWindow:ctor(parent, sCfgFile)
	clsImageView.ctor(self, parent)
	helper.clsCompLoader.ctor(self, sCfgFile)
	clsCoreObject.ctor(self)
	
	AddMemoryMonitor(self)
	
	self:LoadMe()
	
	self._bIsShow = true
	self:FireEvent(const.CORE_EVENT.EC_SHOW, true)
end

function clsWindow:dtor()
	self:FireEvent(const.CORE_EVENT.EC_SHOW, false)
end

function clsWindow:_FixMaskPos()
	if self.mMaskSpr and self.bShowMask then
		local pos = self.mBlockLayer:convertToNodeSpace(cc.p(GAME_CONFIG.DESIGN_W_2, GAME_CONFIG.DESIGN_H_2))
		self.mMaskSpr:setPosition(pos)
	end
end

function clsWindow:Show(bShow)
	if bShow == nil then bShow = true end
	if self._bIsShow == bShow then return end
	self._bIsShow = bShow
	self:setVisible(bShow)
	if bShow then
		self:_FixMaskPos()
	end
	self:FireEvent(const.CORE_EVENT.EC_SHOW, bShow)
end

function clsWindow:IsShow()
	return self._bIsShow
end

function clsWindow:Close()
	ClsUIManager.GetInstance():DestroyWindowEx(self)
end

function clsWindow:SetToCenter()
	self:setPosition(GAME_CONFIG.DESIGN_W_2,GAME_CONFIG.DESIGN_H_2)
	self:_FixMaskPos()
end

-- bModal：是否模态
-- bShowMask：是否显示遮罩 
-- OnClickBlock：遮罩的点击回调
function clsWindow:SetModal(bModal, bShowMask, OnClickBlock, sMaskPath)
	if bModal == nil then bModal = true end
	if bShowMask == nil then bShowMask = true end
	if OnClickBlock then self.OnClickBlock = OnClickBlock end
	
	-- 阻挡
	if self.mBlockLayer then
		self.mBlockLayer:setVisible(bModal)
	elseif bModal then
		self.mBlockLayer = cc.Layer:create()
		self.mBlockLayer:setLocalZOrder(-1)
		KE_SetParent(self.mBlockLayer, self)
		
		local function onToucheBegan(touch, event)
			return utils.IsNodeRealyVisible(self.mBlockLayer)
		end
		local function onToucheMoved(touch, event) 
			
		end
		local function onToucheEnded(touch, event) 
			if self.OnClickBlock then self.OnClickBlock() end
		end
		local listener = cc.EventListenerTouchOneByOne:create()
		listener:registerScriptHandler(onToucheBegan, cc.Handler.EVENT_TOUCH_BEGAN)
		listener:registerScriptHandler(onToucheMoved, cc.Handler.EVENT_TOUCH_MOVED)
		listener:registerScriptHandler(onToucheEnded, cc.Handler.EVENT_TOUCH_ENDED)
		self.mBlockLayer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.mBlockLayer)
		listener:setSwallowTouches(true)
	end
	
	-- 遮罩
	self.bShowMask = bShowMask
	if self.mMaskSpr then
		self.mMaskSpr:setVisible(bShowMask)
	elseif bShowMask then
		self.mMaskSpr = cc.Scale9Sprite:create(sMaskPath or "res/mask.png")
		self.mMaskSpr:setPreferredSize(cc.size(GAME_CONFIG.DESIGN_W+2, GAME_CONFIG.DESIGN_H+2))
		KE_SetParent(self.mMaskSpr, self.mBlockLayer)
	end
	
	self:_FixMaskPos()
end

-------------------------------------------------

function clsWindow:LoadMe()
	self:LoadByCfgFile(self)
end

function clsWindow:SaveUICinfig(sFilePath)
	assert(sFilePath, "未指定存放路径")
	
end

function clsWindow:PlayPopAni()
	if self.mPopAni then
		self:stopAction(self.mPopAni)
		self.mPopAni = nil
	end
	
	self:setScale(0.5)
	
	self.mPopAni = self:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.12, 1.3, 1.3),
		cc.ScaleTo:create(0.1, 1, 1),
		cc.CallFunc:create(function() 
			self.mPopAni=nil 
		end)
	))
end
