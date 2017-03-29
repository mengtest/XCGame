clsIdleState = class("clsIdleState", clsActionState)

function clsIdleState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_IDLE
end

function clsIdleState:OnEnter(obj, args)
	obj:SetAni(const.ANI_IDLE)
	obj:PauseAni()
end

function clsIdleState:OnExit(obj)
	obj:ResumeAni()
end

--@每帧更新
function clsIdleState:FrameUpdate(obj, deltaTime)

end