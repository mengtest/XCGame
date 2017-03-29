---------------
-- 粒子特效
---------------

clsEffectQuad = class("clsEffectQuad", function() return cc.Node:create() end)

function clsEffectQuad:ctor(effectID, res_path, parent, loop_times, callback)
	self.Uid = effectID
	self.sResPath = res_path
	self.iLoopTimes = loop_times or 1
	
	local emitter = cc.ParticleSystemQuad:create(self.sResPath)
	emitter:setPositionType(cc.POSITION_TYPE_GROUPED)
	emitter:setAutoRemoveOnFinish(true)
	emitter:registerScriptHandler(function(state)
		if state == "cleanup" then
			if callback then 
				KE_SetTimeout(1, function() callback() end)
			end
		end
	end)
	KE_SetParent(emitter,self)
	
	if parent then
		KE_SetParent(self, parent)
	end
end

function clsEffectQuad:dtor()
	KE_RemoveFromParent(self)
end

function clsEffectQuad:GetUid() return self.Uid end
function clsEffectQuad:GetResPath() return self.sResPath end
function clsEffectQuad:GetTotalFrame() return self.iTotalFrame end

