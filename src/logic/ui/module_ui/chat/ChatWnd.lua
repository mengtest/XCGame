------------------
-- 聊天界面
------------------
module("ui", package.seeall)

clsChatWnd = class("clsChatWnd", clsWindow)

function clsChatWnd:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_chat/chat_wnd.lua")
	self:setSwallowTouches(false)
	
	local RICH_WID, RICH_HEI = 310, 195
	self.mListView = ccui.ListView:create()
	KE_SetParent(self.mListView, self:GetCompByName("spr_bkg"))
	self.mListView:setPosition(68,48)
	self.mListView:setDirection(ccui.ScrollViewDir.vertical)
	self.mListView:setBounceEnabled(true)
	self.mListView:setSwallowTouches(false)
	self.mListView:setContentSize(cc.size(RICH_WID, RICH_HEI))
	local default_item = ccui.Layout:create()
--	default_item:setTouchEnabled(true)
	default_item:setContentSize(RICH_WID, RICH_HEI)
	self.mListView:setItemModel(default_item)
	self.mListView:pushBackDefaultItem()
	self.mCellParent = self.mListView:getItem(0)
	self.mRichText = clsRichText.new(self.mCellParent, RICH_WID, RICH_HEI)
	self.mRichText:setAnchorPoint(cc.p(0,1))
	self.mRichText:setPosition(0,RICH_HEI)
	
	KE_Director:GetChatMgr():AddListener(self, "new_msg", function(channel, msg)
		if self.iCurChannel == channel then
			self.mRichText:AddText("#r")
			self.mRichText:AddText(msg)
			self.mCellParent:setContentSize( 310, math.max(self.mRichText:getContentSize().height, 200) )
			self.mListView:forceDoLayout()
		end
	end)
	
	--
	local radioButtonGroup = ccui.RadioButtonGroup:create()
	self:addChild(radioButtonGroup)
	radioButtonGroup:addEventListener(function(radioButton, index, iType)
		self:OnChanelChg(index+1)
	end)
	for i = 1, 5 do
		radioButtonGroup:addRadioButton(self:GetCompByName("btn_chanel_"..i))
	end
	radioButtonGroup:setSelectedButton(0)
	
	utils.RegButtonEvent(self:GetCompByName("btn_send"), function()
		local msg = self:GetCompByName("editorinput"):getText()
		if not msg or msg == "" then return end
		local channel = self.iCurChannel
		local sender_id = KE_Director:GetHeroId()
		local sender_name = KE_Director:GetHeroName()
		self:GetCompByName("editorinput"):setText("")
		network.SendPro("s_chat", function() end, channel, msg, sender_id, sender_name)
	end)
	
	utils.RegButtonEvent(self:GetCompByName("btn_showhide"), function()
		local bVisible = not self:GetCompByName("spr_bkg"):isVisible()
		self:GetCompByName("spr_bkg"):setVisible( bVisible )
		self:GetCompByName("btn_showhide"):setTitleText(bVisible and "隐藏" or "聊天")
	--	ClsSystemMgr.GetInstance():EnterSystem("聊天")
	end)
end

function clsChatWnd:dtor()
	KE_Director:GetChatMgr():DelListener(self)
	if self.mRichText then KE_SafeDelete(self.mRichText) self.mRichText = nil end
end

function clsChatWnd:OnChanelChg(iChannel)
	self.iCurChannel = iChannel
	self.mRichText:setString( table.concat(KE_Director:GetChatMgr():GetMsgByChannel(iChannel), "#r") )
end
