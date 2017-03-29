------------------
-- 主角
------------------
clsHero = class("clsHero", clsRole)

-- 构造函数
function clsHero:ctor(iUid, TypeId)
	clsRole.ctor(self, iUid, TypeId)
end

--析构函数
function clsHero:dtor()

end

function clsHero:GetRoleType() 
	return const.ROLE_TYPE.TP_HERO 
end
