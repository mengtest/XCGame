clsSkillState = class("clsSkillState", clsActionState)

function clsSkillState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_SKILL
end

function clsSkillState:OnEnter(obj, args)
	local iSkillIndex = args.iSkillIndex
	local finishCallback = args.finishCallback
	local breakCallback = args.breakCallback
	
	obj:GetSkillMgr():CastSkill(iSkillIndex, 
			function() 
				self:OnComplete(obj) 
				if finishCallback then finishCallback() end
			end, 
			function()
				self:OnComplete(obj)
				if breakCallback then breakCallback() end
			end)
end

function clsSkillState:OnExit(obj)
	obj:SetDamageInfo(false)
	if obj:GetSkillMgr():IsCastingSkill() then
		obj:break_skill()
	end
end

--@每帧更新
function clsSkillState:FrameUpdate(obj, deltaTime)
	
end

function clsSkillState:OnComplete(obj, args)
	obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
	
	if obj:IsInSky() and obj:GetSkyMovState() ~= ROLE_STATE.ST_SKYMOVLINE then
		obj:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = 0,
		})
	end
end
