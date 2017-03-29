--------------------------------
-- 技能类: 控制技能的播放
--
-- 技能 = 施法动作 + 法术体
-- 描述：在第几帧 哪个部位 发出法术体 法术体怎样运动
--------------------------------
local ST_SKILL_READY = 1
local ST_SKILL_PLAYING = 2
local ST_SKILL_FINISH = 3


clsSkill = class("clsSkill")

function clsSkill:ctor(SkillId, theOwner)
	assert(SkillId and theOwner)
	self.iCurState = ST_SKILL_READY		--技能阶段
	self.iSkillId = SkillId				--技能ID
	self.mOwner = theOwner				--施法者
end

function clsSkill:dtor()
	if self.mXTree then
		KE_SafeDelete(self.mXTree)
		self.mXTree = nil
	end
end

function clsSkill:GetUid() return self.iSkillId end
function clsSkill:GetOwner() return self.mOwner end
function clsSkill:IsPlaying() return self.mXTree:IsPlaying() end

-- 播放技能
function clsSkill:Play(finishCallback, breakCallback)
	if self.iCurState == ST_SKILL_PLAYING then assert(false) end
	self.iCurState = ST_SKILL_PLAYING
	
	local theOwner = self.mOwner
	if not theOwner then 
		assert(false, "播放技能时没有施法者！！！")
		self:ToFinishState()
		return false
	end
	
	theOwner:PopSay(setting.T_skill_cfg[self.iSkillId].sSkillName)

	if self.mXTree then
		self.mXTree:Recover()
	else
		local tSkillPlayInfo = setting.GetSkillPlayInfo(self.iSkillId)
		self.mXTree = actree.clsXTree.new()
		self.mXTree:BuildByInfo(tSkillPlayInfo)
	end
	
	self.mXTree:GetXContext():SetPerformer("starman", self.mOwner)
	
	self.mXTree:Play(
		function() 
			self.iCurState = ST_SKILL_FINISH
			if finishCallback then finishCallback(self.iSkillId) end
			print("技能播放完毕")
		end, 
		function()
			self.iCurState = ST_SKILL_FINISH
			if breakCallback then breakCallback(self.iSkillId) end
			print("技能被打断")
		end
	)

	return true
end

-- 中断
function clsSkill:BreakSkill()
	self.mXTree:Stop()
end
