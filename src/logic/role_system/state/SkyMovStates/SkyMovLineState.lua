clsSkyMovLineState = class("clsSkyMovLineState", clsSkyMovementState)

function clsSkyMovLineState:ctor()
	clsSkyMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_SKYMOVLINE
end

function clsSkyMovLineState:OnEnter(obj, args)
	assert(is_number(args.jmpSpeed))
	assert(args.callback==nil or is_function(args.callback))
	obj:SetCurSkySpeed(args.jmpSpeed)
	obj._jump_callback = args.callback
end

function clsSkyMovLineState:OnExit(obj)
	obj:SetCurSkySpeed(0)
	obj._jump_callback = nil
end

--@每帧更新
function clsSkyMovLineState:FrameUpdate(obj, deltaTime)
	local JumpSpeed = obj:AddCurSkySpeed(-1)
	local newH = obj:GetPositionH() + JumpSpeed
	
	if newH > 0 then
		obj:SetPositionH(newH)
	else
		obj:SetPositionH(0)
		self:OnComplete(obj)
	end
end

function clsSkyMovLineState:OnComplete(obj, args)
	assert(not obj:IsInSky(), "怎么还在空中我去")
	
	local jump_callback = obj._jump_callback
	
	obj:GetStateMgr():_SetSkyMovState(obj, ROLE_STATE.ST_SKYBRIDGE, {to_state = ROLE_STATE.ST_SKYMOVREST})
	
	if obj:GetActState() == ROLE_STATE.ST_FLIGHT then
		obj:GetActStateObj():OnComplete(obj)
	else
		obj:Turn2ActState(ROLE_STATE.ST_IDLE)
	end
	
	if jump_callback then
		jump_callback()
	end
end
