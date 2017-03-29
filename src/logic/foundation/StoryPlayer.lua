----------------------------------
-- 剧情播放器
--
--[[
ClsStoryPlayer.GetInstance():PlayStory( 
			"test_story_1", 
			function() log_warn("播放完毕回调") end, 
			function() log_warn("剧情被打断") end )
]]--
----------------------------------

ClsStoryPlayer = class("ClsStoryPlayer")
ClsStoryPlayer.__is_singleton = true

function ClsStoryPlayer:ctor()
	self.mCurStory = nil
	self.sCurStoryName = nil
	self._OnFinished = nil
	self._OnBreaked = nil
end

function ClsStoryPlayer:dtor()
	self:DestoryCurStory()
end

function ClsStoryPlayer:IsPlayingStory()
	return self.mCurStory ~= nil
end

function ClsStoryPlayer:PlayStory(sFileName, OnFinished, OnBreaked)
	if self:IsPlayingStory() then 
		print("上一剧情尚未结束: ", self.sCurStoryName)
		return 
	end
	
	local StoryInfo = setting.GetStoryCfg(sFileName)
	assert(StoryInfo, "不存在该剧情文件："..sFileName)
	if not StoryInfo then return end
	
	self.sCurStoryName = sFileName
	self:PlayInfo(StoryInfo, OnFinished, OnBreaked)
end

function ClsStoryPlayer:PlayInfo(StoryInfo, OnFinished, OnBreaked)
	if self:IsPlayingStory() then 
		print("上一剧情尚未结束: ", self.sCurStoryName)
		return 
	end
	
	self._OnFinished = OnFinished
	self._OnBreaked = OnBreaked
	self:CreateStoryPanel()
	print("开始播放剧情: ", self.sCurStoryName)
	
	self.mCurStory = actree.clsXTree.new()
	self.mCurStory:BuildByInfo(StoryInfo)
	if self.mCurStory:GetXContext():HasAtomId("starman") then
		local hero = ClsRoleMgr.GetInstance():CreateHero()
		if hero then hero:EnterMap(500, 100) end
		self.mCurStory:GetXContext():SetPerformer("starman", hero)
	end
	self.mCurStory:Play(function() 
		self:OnStoryPlayOver() 
	end)
end

--正常播放结束
function ClsStoryPlayer:OnStoryPlayOver()
	print("剧情播放完毕: ", self.sCurStoryName)
	if self._OnFinished then 
		self._OnFinished(self.sCurStoryName) 
		self._OnFinished = nil
	end
	self:DestoryCurStory()
end

--跳过剧情
function ClsStoryPlayer:BreakStory()
	if not self:IsPlayingStory() then return end
	print("跳过剧情：",self.sCurStoryName)
	if self._OnBreaked then 
		self._OnBreaked(self.sCurStoryName) 
		self._OnBreaked = nil
	end
	self:DestoryCurStory()
end

function ClsStoryPlayer:DestoryCurStory()
	if self.mCurStory then
		KE_SafeDelete(self.mCurStory)
		self.mCurStory = nil 
	end
	self.sCurStoryName = nil
	self._OnFinished = nil
	self._OnBreaked = nil
	
	self:DestoryStoryPanel()
end

function ClsStoryPlayer:CreateStoryPanel()
	if self.mStoryPanel then return self.mStoryPanel end
	local Parent = KE_Director:GetLayerMgr():GetLayer(const.LAYER_GUIDE)
	if not Parent then return end
	
	self.mStoryPanel = ui.clsWindow.new(Parent, "src/data/uiconfigs/ui_story/story_panel.lua")
	self.mStoryPanel:SetModal(true,false,function() end)
	self.mStoryPanel:GetCompByName("spr_bottom"):setScaleX(GAME_CONFIG.SCREEN_W/1280)
	self.mStoryPanel:GetCompByName("btn_break"):setPosition(GAME_CONFIG.SCREEN_W_2,GAME_CONFIG.SCREEN_H_2)
	utils.RegButtonEvent(self.mStoryPanel:GetCompByName("btn_break"), function()
		KE_SetTimeout(1,function() self:BreakStory() end)
	end)
	
	return self.mStoryPanel
end

function ClsStoryPlayer:DestoryStoryPanel()
	if self.mStoryPanel then
		KE_SafeDelete(self.mStoryPanel)
		self.mStoryPanel = nil
	end
end
