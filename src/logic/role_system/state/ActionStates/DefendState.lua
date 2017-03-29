clsDefendState = class("clsDefendState", clsActionState)

function clsDefendState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_DEFEND
end

function clsDefendState:OnEnter(obj, args)
	obj:SetAni(const.ANI_DEF)
	log_warn("防御开始")
	local iTime = 2.0
	obj:CreateAbsTimerDelay("tmdefend", iTime, function()
		self:OnComplete(obj)
	end)
end

function clsDefendState:OnExit(obj)
	obj:DestroyTimer("tmdefend")
	log_warn("防御结束")
end

--@每帧更新
function clsDefendState:FrameUpdate(obj, deltaTime)
	
end

function clsDefendState:OnComplete(obj, args)
	obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
end