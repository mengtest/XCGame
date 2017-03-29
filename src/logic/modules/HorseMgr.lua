----------------
-- 坐骑管理器
----------------
clsHorseManager = class("clsHorseManager", clsCoreObject)
clsHorseManager.__is_singleton = true

function clsHorseManager:ctor()
	clsCoreObject.ctor(self)
	self.tMyHorses = {}		--拥有的坐骑列表
	self.iRiding = nil		--使用中的坐骑
end

function clsHorseManager:dtor()

end

function clsHorseManager:AddHorse(iHorseId, Info)
	self.tMyHorses[iHorseId] = Info
end

function clsHorseManager:UseHorse(iHorseId)
	if not self.tMyHorses[iHorseId] then
		return false,"尚未获得该坐骑"
	end
	self.iRiding = iHorseId
end

function clsHorseManager:RestHorse()
	self.iRiding = nil
end

function clsHorseManager:GetMyHorses()
	return self.tMyHorses
end

function clsHorseManager:GetHorse(iHorseId)
	return self.tMyHorses[iHorseId]
end

function clsHorseManager:GetUsingHorse()
	return self.iRiding and self.tMyHorses[self.iRiding]
end
