---------------------
-- 天气系统
---------------------
local clsEmitter = class("clsEmitter", function() return cc.Node:create() end)

function clsEmitter:ctor(Parent, iSize)
	KE_SetParent(self, Parent)
	self._size = iSize or 500
	self.tPartileList = {}
end

function clsEmitter:dtor()
	KE_KillTimer(self._timer_update)
	KE_KillTimer(self._timer_factorx)
	KE_KillTimer(self._timer_new)
	KE_RemoveFromParent(self)
end

function clsEmitter:AddParticle(respath)
	respath = respath or "res/icons/star_1.png"
	self.tPartileList[respath] = self.tPartileList[respath] or {}
	local spr = cc.Sprite:create(respath)
	self:addChild(spr)
	spr:setScale(math.random(8,28)/spr:getContentSize().width)
	table.insert(self.tPartileList[respath], spr)
	return spr
end

function clsEmitter:DelParticle(delSpr)
	for _, list in pairs(self.tPartileList) do
		for i, spr in ipairs(list) do
			if delSpr == spr then
				table.remove(list,i)
				KE_SafeDelete(spr)
				return
			end
		end
	end
end

function clsEmitter:Play()
	self._timer_new = KE_SetInterval(1, function()
		local spr = self:AddParticle("res/icons/item/temp.png")
		spr:setPosition(math.random(1,1000),math.random(300,700))
		
		spr._dir = math.random(1,10) >= 6
		spr._factorX = math.random(1,30)/100
		spr._factorY = -math.random(1,20)/200
		spr._live = math.random(15,20) * 60
	end)
	
	self._timer_update = KE_SetInterval(1, function()
		for _, list in pairs(self.tPartileList) do
			for _, spr in ipairs(list) do
				if spr._live <= 0 then
					--self:DelParticle(spr)
					spr:setOpacity(100)
				else
					spr:setPosition( spr:getPositionX() + (spr._dir and 1 or -1)*spr._factorX, spr:getPositionY() + spr._factorY )
					spr._factorY = spr._factorY - 0.0002
					spr._live = spr._live - 1
				end
			end
		end
	end)
	
	self._timer_factorx = KE_SetInterval(333, function()
		for _, list in pairs(self.tPartileList) do
			for _, spr in ipairs(list) do
				if math.random(1,100) <= 36 then
					spr._factorX = (math.random(1,30))/100
					spr._dir = not spr._dir
				end
			end
		end
	end)
end

function clsEmitter:StopPlay()
	KE_KillTimer(self._timer_factorx)
	KE_KillTimer(self._timer_new)
end

------------------------------------------------------------------

ClsWeatherMgr = class("ClsWeatherMgr")
ClsWeatherMgr.__is_singleton = true

function ClsWeatherMgr:ctor(Parent)
	
end

function ClsWeatherMgr:dtor()
	
end

function ClsWeatherMgr:StartSnow()
	if not ClsLayerMgr.GetInstance():GetLayer(const.LAYER_WEATHER) then return end
	if tolua.isnull(self.mSnowEmitter) then self.mSnowEmitter = nil end
	if self.mSnowEmitter then return end
	self.mSnowEmitter = cc.ParticleSnow:createWithTotalParticles(1000)
	local emitter = self.mSnowEmitter
	emitter:setPositionType(cc.POSITION_TYPE_GROUPED)
	local rain_batch = cc.ParticleBatchNode:createWithTexture(emitter:getTexture())
	KE_SetParent(emitter, rain_batch)
	KE_SetParent(rain_batch, ClsLayerMgr.GetInstance():GetLayer(const.LAYER_WEATHER))
	emitter:setPosition(500,700)
end

function ClsWeatherMgr:StopSnow()
	if self.mSnowEmitter then
		KE_SafeDelete(self.mSnowEmitter)
		self.mSnowEmitter = nil 
	end
end

function ClsWeatherMgr:StartRain()
	
end

function ClsWeatherMgr:StopRain()
	
end

function ClsWeatherMgr:StartFog()

end

function ClsWeatherMgr:StopFog()

end
