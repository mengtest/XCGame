clsFreezeState = class("clsFreezeState", clsActionState)

function clsFreezeState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_FREEZE
end

function clsFreezeState:OnEnter(obj, args)
--	obj:PauseAni()
	obj:SetAni(const.ANI_ABN)
	
	obj:CreateTimerDelay("tmfreezeact", args.iFreeseTime, function()
		self:OnComplete(obj)
	end)
	
	obj.iceSpr = cc.Sprite:create("effects/effect_img/ice.png")
	KE_SetParent(obj.iceSpr, obj)
	obj.iceSpr:setPosition(0,100)
end

function clsFreezeState:OnExit(obj)
	obj:DestroyTimer("tmfreezeact")
	KE_SafeDelete(obj.iceSpr)
	obj.iceSpr = nil
end

--@每帧更新
function clsFreezeState:FrameUpdate(obj, deltaTime)
	
end

function clsFreezeState:OnComplete(obj, args)
--	obj:ResumeAni()
	
	if obj:IsInSky() then
		obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_FLIGHT})
	else
		obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
	end
end