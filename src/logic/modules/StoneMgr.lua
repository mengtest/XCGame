----------------
-- 宝石管理器
----------------
clsStoneManager = class("clsStoneManager", clsCoreObject)
clsStoneManager.__is_singleton = true

function clsStoneManager:ctor()
	clsCoreObject.ctor(self)
	
end

function clsStoneManager:dtor()
	
end
