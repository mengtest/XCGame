----------------
-- VIP管理器
----------------
clsVipManager = class("clsVipManager", clsCoreObject)
clsVipManager.__is_singleton = true

function clsVipManager:ctor()
	clsCoreObject.ctor(self)
	
end

function clsVipManager:dtor()

end
