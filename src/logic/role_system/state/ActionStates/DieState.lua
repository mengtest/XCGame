clsDieState = class("clsDieState", clsActionState)

function clsDieState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_DIE
end

function clsDieState:OnEnter(obj, args)
	obj:RemoveFromPhysWorld()
	obj:RemoveFromTeam()
	
	obj:SetAni(const.ANI_DIE)
	obj:PauseAni()
	
	local del_id = obj:GetUid()
	obj:CreateTimerDelay("tm_die2del", GAME_CONFIG.FPS, function()
		ClsRoleMgr.GetInstance():DestroyRole(del_id)
	end)
end

function clsDieState:OnExit(obj)
	obj:DestroyTimer("tm_die2del")
	obj:ResumeAni()
end

--@每帧更新
function clsDieState:FrameUpdate(obj, deltaTime)

end