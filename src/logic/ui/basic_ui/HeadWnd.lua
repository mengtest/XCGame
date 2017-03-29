------------------
-- 头像框
------------------
module("ui", package.seeall)

local HEAD_SIZE = 100
local HALF_HEAD_SIZE = 50

local ORDER_SPRFRAME = 1
local ORDER_SPRHEAD = 2

local ALL_STYLES = {
	[1] = "res/card/frames/head_frame_1.png",
	[2] = "res/card/frames/head_frame_2.png",
	[3] = "res/card/frames/head_frame_3.png",
}


local clsHeadBase = class("clsHeadBase", function() return ccui.Button:create() end)

function clsHeadBase:ctor(parent)
	self:setScale9Enabled(true)
	self:setContentSize(HEAD_SIZE, HEAD_SIZE)
	if parent then KE_SetParent(self, parent) end
end

function clsHeadBase:dtor()
	KE_RemoveFromParent(self)
end

-----------------------------------------------------

clsHeadWnd = class("clsHeadWnd", clsHeadBase, clsCoreObject)

function clsHeadWnd:ctor(parent, HeadId, iStyle)
	clsHeadBase.ctor(self, parent)
	clsCoreObject.ctor(self)
	
	--
	self._HeadId = nil
	--
	self._bTipsEnabled = true 
	--
	self._sFrameImg = nil
	self._sHeadImg = nil
	--
	self.mSprFrame = nil
	self.mSprHead = nil
	
	self:SetFrameStyle(iStyle or 1)
	self:SetHeadId(HeadId)
	self:_init_widget_events()
end

function clsHeadWnd:dtor()
	
end

function clsHeadWnd:SetFrameStyle(iStyle)
	assert(ALL_STYLES[iStyle], "无效的样式")
	self:SetFrameImg(ALL_STYLES[iStyle])
end

function clsHeadWnd:_ShowTips()
	if not self._bTipsEnabled then return end
	utils.TellTips( "TIP_ROLE", self, {RoleData=self._RoleData} )
end

function clsHeadWnd:_init_widget_events()
	local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			
		elseif eventType == ccui.TouchEventType.moved then
			
    	elseif eventType == ccui.TouchEventType.ended then
    		self:_ShowTips()
    	elseif eventType == ccui.TouchEventType.canceled then
        	
        end 
    end
    self:addTouchEventListener(touchEvent)
end

function clsHeadWnd:SetFrameImg(imgPath)
	if self._sFrameImg == imgPath then return end
	self._sFrameImg = imgPath
	KE_SafeDelete(self.mSprFrame)
	self.mSprFrame = nil
	if not imgPath or imgPath=="" then return end
	self.mSprFrame = cc.Sprite:create(imgPath)
	KE_SetParent(self.mSprFrame, self, ORDER_SPRFRAME)
	self.mSprFrame:setPosition(HALF_HEAD_SIZE,HALF_HEAD_SIZE)
end

function clsHeadWnd:SetHeadImg(imgPath)
	if self._sHeadImg == imgPath then return end
	self._sHeadImg = imgPath
	
	KE_SafeDelete(self.mSprHead)
	self.mSprHead = nil
	if not imgPath or imgPath=="" then return end
	
	self.mSprHead = cc.Sprite:create(imgPath)
	KE_SetParent(self.mSprHead, self, ORDER_SPRHEAD)
	
	if self._sFrameImg == ALL_STYLES[1] then
		self.mSprHead:setPosition(53,60)
	elseif self._sFrameImg == ALL_STYLES[2] then
		self.mSprHead:setScale(0.8)
		self.mSprHead:setPosition(52,60)
	elseif self._sFrameImg == ALL_STYLES[3] then
		self.mSprHead:setScale(0.8)
		self.mSprHead:setPosition(52,61)
	else 
		self.mSprHead:setPosition(HALF_HEAD_SIZE,HALF_HEAD_SIZE)
	end
end

--------------------------

function clsHeadWnd:SetHeadId(HeadId)
	if self._HeadId == HeadId then return end
	self._HeadId = HeadId
	local Info = setting.T_head_cfg[HeadId]
	assert(Info, "未配置的头像："..HeadId)
	self:SetHeadImg(Info.respath)
end

function clsHeadWnd:GetHeadId()
	return self._HeadId
end
