-----------------
--
-----------------
clsGrdMovPathState = class("clsGrdMovPathState", clsGrdMovementState)

function clsGrdMovPathState:ctor()
	clsGrdMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_GRDMOVPATH
end

function clsGrdMovPathState:OnEnter(obj, args)
	--if obj:IsInSky() then log_warn("角色还在空中飘: "..obj:GetPositionH()) end
	assert(args.roadpath)
	obj:SetRoadPath(args.roadpath)
	obj._pathto_succ = args.on_reached
	obj._pathto_fail = args.on_breaked
end

function clsGrdMovPathState:OnExit(obj)
	obj:ClearRoadPath()
	obj._pathto_succ = nil
	local on_breaked = obj._pathto_fail
	obj._pathto_fail = nil
	if on_breaked then on_breaked() end
end

--@每帧更新
function clsGrdMovPathState:FrameUpdate(obj, deltaTime)
	local RoadPath = obj:GetRoadPath()
	
	if RoadPath then
		local x, y, dir, is_end = RoadPath:get_next(obj:GetCurMoveSpeed())
		obj:setPosition(x, y)
		obj:SetDirection(dir)
		if is_end then
			self:OnComplete(obj)
		end
	else
		obj:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
		obj:Turn2ActState(ROLE_STATE.ST_IDLE)
	end
end

function clsGrdMovPathState:OnComplete(obj, args)
	local pathto_callback = obj._pathto_succ
	obj._pathto_succ = nil
	obj._pathto_fail = nil
	
	obj:ClearRoadPath()
	obj:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	obj:Turn2ActState(ROLE_STATE.ST_IDLE)
	
	if pathto_callback then
		pathto_callback()
	end
end
