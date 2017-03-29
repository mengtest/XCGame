------------------
-- clsMonster
------------------
clsMonster = class("clsMonster", clsRole)

-- 构造函数
function clsMonster:ctor(iUid, TypeId)
	clsRole.ctor(self, iUid, TypeId)
end

--析构函数
function clsMonster:dtor()
	
end

function clsMonster:GetRoleType() 
	return const.ROLE_TYPE.TP_MONSTER 
end
