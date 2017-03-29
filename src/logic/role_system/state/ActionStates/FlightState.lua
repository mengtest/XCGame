clsFlightState = class("clsFlightState", clsActionState)

function clsFlightState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_FLIGHT
end

function clsFlightState:OnEnter(obj, args)
	obj:ClearRoadPath()
	obj:SetAni(const.ANI_FLIGHT_UP)
end

function clsFlightState:OnExit(obj)
	
end

--@每帧更新
function clsFlightState:FrameUpdate(obj, deltaTime)
	if obj:GetCurSkySpeed() > 0 then
		obj:SetAni(const.ANI_FLIGHT_UP)
	else
		obj:SetAni(const.ANI_FLIGHT_DOWN)
	end
end

function clsFlightState:OnComplete(obj, args)
	obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
end
