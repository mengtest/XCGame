----------------
-- 兑换管理器
----------------
clsExchangeManager = class("clsExchangeManager", clsCoreObject)
clsExchangeManager.__is_singleton = true

clsExchangeManager:RegSaveVar("D2MRemainTimes", TYPE_CHECKER.INT)
clsExchangeManager:RegSaveVar("D2MMaxTimes", TYPE_CHECKER.INT)

function clsExchangeManager:ctor()
	clsCoreObject.ctor(self)
	self:SetD2MRemainTimes(22)
	self:SetD2MMaxTimes(100)
end

function clsExchangeManager:dtor()
	
end
