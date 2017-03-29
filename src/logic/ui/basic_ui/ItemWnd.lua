------------------
-- 物品框
------------------
module("ui", package.seeall)

--
local T_item_cfg = setting.T_item_cfg
local ITEM_SIZE = 100
local HALF_ITEM_SIZE = 50
--
local ORDER_SPRITEM = 2
local ORDER_SPRFRAME = 1
local ORDER_SPRHIGHLIGHT = 3
local ORDER_LABELAMOUNT = 4
local ORDER_SPRLOCK = 5 

-- 编号0为窗格外框  编号1到5为品质框
local ALL_STYLES = {
	[1] = {
		[0] = "res/icons/frame/item_panel_empty.png",
		[1] = "res/icons/frame/item_panel_gray.png",
		[2] = "res/icons/frame/item_panel_green.png",
		[3] = "res/icons/frame/item_panel_blue.png",
		[4] = "res/icons/frame/item_panel_purple.png",
		[5] = "res/icons/frame/item_panel_yellow.png",
	},
	[2] = {
		[0] = "res/icons/frame/frame_soul_empty.png",
		[1] = "res/icons/frame/frame_soul_gray.png",
		[2] = "res/icons/frame/frame_soul_green.png",
		[3] = "res/icons/frame/frame_soul_blue.png",
		[4] = "res/icons/frame/frame_soul_purple.png",
		[5] = "res/icons/frame/frame_soul_yellow.png",
	},
}


local clsItemWndBase = class("clsItemWndBase", function() return ccui.Button:create() end)

function clsItemWndBase:ctor(parent)
	self:setScale9Enabled(true)
	self:setContentSize(ITEM_SIZE,ITEM_SIZE)
	if parent then KE_SetParent(self, parent) end
end

function clsItemWndBase:dtor()
	KE_RemoveFromParent(self)
end

------------------------------------------------------------------

clsItemWnd = class("clsItemWnd", clsItemWndBase, clsCoreObject)

clsItemWnd:RegisterEventType(const.CORE_EVENT.ec_touch_began)
clsItemWnd:RegisterEventType(const.CORE_EVENT.ec_touch_moved)
clsItemWnd:RegisterEventType(const.CORE_EVENT.ec_touch_ended)
clsItemWnd:RegisterEventType(const.CORE_EVENT.ec_touch_canceled)

function clsItemWnd:ctor(Parent, iStyle)
	clsItemWndBase.ctor(self, Parent)
	clsCoreObject.ctor(self)
	
	--
	self._ItemId = nil
	self._ItemType = nil
	self._ItemAmount = nil
	--
	self._bHighLight = false
	self._bLocked = false 
	self._bTipsEnabled = false 
	self._StyleTbl = nil
	--
	self._sFrameImg = nil
	self._sItemImg = nil
	--
	self.mSprFrame = nil
	self.mSprItem = nil
	self.mSprHighLight = nil
	self.mLabelAmount = nil 
	self.mSprLock = nil 
	
	--
	self:_init_widget_events()
	self:SetFrameStyle(iStyle or 1)
end

function clsItemWnd:dtor()
	
end

----------------------
-- 私有函数
----------------------
function clsItemWnd:SetFrameStyle(iStyle)
	assert(ALL_STYLES[iStyle], "无效的样式")
	self._StyleTbl = ALL_STYLES[iStyle]
	local iQuality = self:GetItemQuality()
	self:_SetFrameImg(self._StyleTbl[iQuality or 0])
end

function clsItemWnd:_ShowTips()
	if not self._bTipsEnabled then return end
	if self._ItemType then
		utils.TellTips( "TIP_ITEM", self, {ItemType=self._ItemType,ItemId=self._ItemId} )
	end
end

function clsItemWnd:_init_widget_events()
	local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self:FireEvent(const.CORE_EVENT.ec_touch_began, self)
			
		elseif eventType == ccui.TouchEventType.moved then
			self:FireEvent(const.CORE_EVENT.ec_touch_moved, self)
			
    	elseif eventType == ccui.TouchEventType.ended then
    		self:_ShowTips()
    		self:FireEvent(const.CORE_EVENT.ec_touch_ended, self)
    		
    	elseif eventType == ccui.TouchEventType.canceled then
        	self:FireEvent(const.CORE_EVENT.ec_touch_canceled, self)
        	
        end 
    end
    self:addTouchEventListener(touchEvent)
end

function clsItemWnd:_SetFrameImg(imgPath)
	if self._sFrameImg == imgPath then return end
	self._sFrameImg = imgPath
	
	KE_SafeDelete(self.mSprFrame)
	self.mSprFrame = nil
	if not imgPath or imgPath=="" then return end
	self.mSprFrame = cc.Sprite:create(imgPath)
	KE_SetParent(self.mSprFrame, self, ORDER_SPRFRAME)
	self.mSprFrame:setPosition(HALF_ITEM_SIZE,HALF_ITEM_SIZE)
end

function clsItemWnd:_SetItemImg(imgPath)
	if self._sItemImg == imgPath then return end
	self._sItemImg = imgPath
	
	KE_SafeDelete(self.mSprItem)
	self.mSprItem = nil
	if not imgPath or imgPath=="" then return end
	self.mSprItem = cc.Sprite:create(imgPath)
	KE_SetParent(self.mSprItem, self, ORDER_SPRITEM)
	self.mSprItem:setPosition(HALF_ITEM_SIZE,HALF_ITEM_SIZE)
end

----------------------
-- 公有函数
----------------------

function clsItemWnd:SetTipsEnable(bEnable)
	self._bTipsEnabled = bEnable
end

function clsItemWnd:SetHighLight(bHighLight)
	if self._bHighLight == bHighLight then return end
	self._bHighLight = bHighLight
	
	if self.mSprHighLight then
		self.mSprHighLight:setVisible(bHighLight)
	elseif bHighLight then
		self.mSprHighLight = cc.Scale9Sprite:create("res/icons/frame/frame_choosed_1.png")
		KE_SetParent(self.mSprHighLight, self, ORDER_SPRITEM)
		self.mSprHighLight:setContentSize(ITEM_SIZE,ITEM_SIZE)
		self.mSprHighLight:setPosition(HALF_ITEM_SIZE,HALF_ITEM_SIZE)
	end
end

function clsItemWnd:SetLocked(bLocked)
	if self._bLocked == bLocked then return end
	self._bLocked = bLocked
	
	if self.mSprLock then
		self.mSprLock:setVisible(bLocked)
	elseif bLocked then
		self.mSprLock = cc.Sprite:create("res/icons/lock_single_item.png")
		KE_SetParent(self.mSprLock, self, ORDER_SPRLOCK)
		self.mSprLock:setPosition(HALF_ITEM_SIZE,HALF_ITEM_SIZE)
	end
end

function clsItemWnd:SetItemAmount(iCnt)
	iCnt = iCnt or 0
	assert(is_number(iCnt))
	if self._ItemAmount == iCnt then return end
	self._ItemAmount = iCnt
	
	if not self.mLabelAmount then
		self.mLabelAmount = cc.Label:createWithTTF(const.DEF_FONT_CFG(), "0") 
		KE_SetParent(self.mLabelAmount, self, ORDER_LABELAMOUNT)
		self.mLabelAmount:setAnchorPoint(cc.p(1,1))
		self.mLabelAmount:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.mLabelAmount:setPosition(95,95)
	end
	self.mLabelAmount:setString(iCnt>1 and iCnt or "")
end

function clsItemWnd:SetItemAmountEx(iCnt, iMaxCnt)
	assert(is_number(iCnt) and is_number(iMaxCnt))
	if self._ItemAmount == iCnt and self._MaxItemAmount == iMaxCnt then return end
	self._ItemAmount = iCnt
	self._MaxItemAmount = iMaxCnt
	
	if not self.mLabelAmount then
		self.mLabelAmount = cc.Label:createWithTTF(const.DEF_FONT_CFG(), "0") 
		KE_SetParent(self.mLabelAmount, self, ORDER_LABELAMOUNT)
		self.mLabelAmount:setAnchorPoint(cc.p(1,1))
		self.mLabelAmount:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.mLabelAmount:setPosition(95,95)
	end
	self.mLabelAmount:setString(string.format("%d/%d",iCnt,iMaxCnt))
end

function clsItemWnd:SetItemType(iItemType)
	if self._ItemId and iItemType then
		local ItemData = KE_Director:GetItemMgr():GetItem(self._ItemId)
		if ItemData then
			assert(iItemType==ItemData:GetItemType(), "ItemType和对应的物品ID不匹配")
		end
	end
	
	if self._ItemType == iItemType then return end
	self._ItemType = iItemType
	
	if iItemType then
		assert(T_item_cfg[iItemType], "不存在该物品类型，请检查配置文件: T_item_cfg.lua   "..iItemType)
		local info = T_item_cfg[iItemType]
		self:_SetFrameImg(self._StyleTbl[info.Quality or 0])
		self:_SetItemImg(setting.GetItemImgPath(iItemType))
	else 
		self._ItemId = nil 
		self:_SetFrameImg(self._StyleTbl[0])
		self:_SetItemImg(nil)
		self:SetItemAmount(nil) 
	end
end	

function clsItemWnd:SetItemId(iItemId)
	self._ItemId = iItemId
	if iItemId then
		local ItemData = KE_Director:GetItemMgr():GetItem(iItemId)
		if ItemData then
			self:SetItemType(ItemData:GetItemType())
		end
	end
end

function clsItemWnd:IsEmpty() 
	return self._ItemType == nil 
end

function clsItemWnd:GetSize() 
	local conSize = self:getContentSize()  
	return conSize.width, conSize.height 
end

function clsItemWnd:GetItemId() return self._ItemId end
function clsItemWnd:GetItemType() return self._ItemType end
function clsItemWnd:GetItemAmount() return self._ItemAmount end
function clsItemWnd:IsHighLight() return self._bHighLight end
function clsItemWnd:IsLocked() return self._bLocked end 
function clsItemWnd:GetItemQuality() 
	if not self._ItemType then return nil end
	return T_item_cfg[self._ItemType].Quality
end
function clsItemWnd:GetItemKind() 
	if not self._ItemType then return nil end
	return T_item_cfg[self._ItemType].ItemKind
end

--[[
ItemInfo = {
	["ItemId"] 		= [int],	--可选
	["ItemType"] 	= [int],	--必须
	["iCount"] 		= [int], 	--可选
}
]]--
function clsItemWnd:SetItemInfo(ItemInfo)
	if ItemInfo == nil then
		self:SetItemId(nil)
		self:SetItemType(nil)
		self:SetItemAmount(nil)
	else 
		self:SetItemId(ItemInfo.ItemId) 
		self:SetItemType(ItemInfo.ItemType)
		self:SetItemAmount(ItemInfo.iCount)
	end
end

function clsItemWnd:UpdateItemInfo(NewInfo)
	if NewInfo.ItemId then self:SetItemId(NewInfo.ItemId) end
	if NewInfo.ItemType then self:SetItemType(NewInfo.ItemType) end
	if NewInfo.iCount then self:SetItemAmount(NewInfo.iCount) end
end

function clsItemWnd:GetItemInfo()
	return {
		["ItemType"] = self._ItemType,
		["ItemId"] = self._ItemId,
		["iCount"] = self._ItemAmount,
	}
end
