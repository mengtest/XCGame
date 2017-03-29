---------------
-- 序列帧特效
---------------

clsEffectSeq = class("clsEffectSeq", function() return cc.Sprite:create() end)

function clsEffectSeq:ctor(effectID, res_path, parent, loop_times, callback)
	self.Uid = effectID
	self.sResPath = res_path
	self.iLoopTimes = loop_times or 1
	
	if parent then KE_SetParent(self, parent) end
	self:setScale(0.4)
	self:_LoadBody(callback)
end

function clsEffectSeq:dtor()
	self:_UnloadBody()
	KE_RemoveFromParent(self)
end

function clsEffectSeq:GetUid() return self.Uid end
function clsEffectSeq:GetResPath() return self.sResPath end
function clsEffectSeq:GetTotalFrame() return self.iTotalFrame end

function clsEffectSeq:_LoadBody(callback)
	ClsResMgr.GetInstance():AddSpriteFrames(self.sResPath)
	local EffName = io.GetFileName(self.sResPath)
	assert(EffName, "解析特效名失败："..self.sResPath)
	
	local InstSprFrameCache = cc.SpriteFrameCache:getInstance()
	local aniFrames = {}
	local frameIdx = 0
	while true do
		local frameName = string.format("%s_%d.png", EffName, frameIdx)
	    local spriteFrame = InstSprFrameCache:getSpriteFrame(frameName)
		if not spriteFrame then break end
		aniFrames[#aniFrames+1] = spriteFrame
		frameIdx = frameIdx + 1
	end
	
	self.iTotalFrame = #aniFrames
	assert(self.iTotalFrame>0, "无效的特效：总帧数小于1"..self.iTotalFrame)
	
	local animation = cc.Animation:createWithSpriteFrames(aniFrames, 0.08, self.iLoopTimes)
   	self:runAction(cc.Sequence:create(
   		cc.Animate:create(animation), 
   		cc.CallFunc:create(function()
   			if callback then callback() end
   		end)
   	))
end

function clsEffectSeq:_UnloadBody()
	ClsResMgr.GetInstance():SubSpriteFrames(self.sResPath)
end
