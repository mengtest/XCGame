------------------
-- 主界面
------------------
module("ui", package.seeall)

clsGMPanel = class("clsGMPanel", clsWindow)

function clsGMPanel:ctor(parent)
	clsWindow.ctor(self, parent)
	self.tFeatureBtns = {}
	self:SetModal(true, true, function() self:Close() end)
	self:InitFeatureBtns()
end

function clsGMPanel:dtor()
	
end

function clsGMPanel:InitFeatureBtns()
	self:AddFeatureBtn("播放剧情", function()
		self:Show(false)
		local story_name = "test_story_1"
		ClsStoryPlayer.GetInstance():PlayStory(story_name, function() end)
	end)
	self:AddFeatureBtn("停止剧情", function()
		local story_name = "test_story_1"
		ClsStoryPlayer.GetInstance():BreakStory(story_name)
	end)
	self:AddFeatureBtn("重新登录", function()
		KE_Director:GetStateMachine():ReLogin()
	end)
	self:AddFeatureBtn("退出游戏", function()
		KE_Director:GetStateMachine():ExitApp()
	end)
	self:AddFeatureBtn("剧情编辑器", function()
		editorstory.ClsStoryEditor.GetInstance()
	end)
end

function clsGMPanel:AddFeatureBtn(sKey, ClickFunc)
	local Btn = ccui.Button:create()
	Btn:setScale9Enabled(true)
	Btn:setContentSize(200,80)
	Btn:loadTextures("res/uiface/buttons/btn_blue.png", "res/uiface/buttons/btn_green.png", "")
	Btn:setTitleText(sKey)
	KE_SetParent(Btn, self)
	
	table.insert(self.tFeatureBtns, Btn)
	local row = #self.tFeatureBtns%8    if row==0 then row = 8 end
	Btn:setPosition(math.ceil(#self.tFeatureBtns/8)*200-80, row*90-20)
	
	utils.RegButtonEvent(Btn, function()
		ClickFunc()
	end)
end
