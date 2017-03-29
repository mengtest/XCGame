------------------
-- 聊天界面
------------------
module("ui", package.seeall)

clsChatPanel = class("clsChatPanel", clsCommonFrame)

function clsChatPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_chat/chat_panel.lua", "聊天")
	
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
end

function clsChatPanel:dtor()
	
end

function clsChatPanel:OnChanelChg(iChannel)
	self.iCurChannel = iChannel
end
