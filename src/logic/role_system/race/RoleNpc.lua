------------------
-- NPC
------------------
clsNpc = class("clsNpc", clsRole)

-- 构造函数
function clsNpc:ctor(iUid, TypeId)
	clsRole.ctor(self, iUid, TypeId)
end

--析构函数
function clsNpc:dtor()
	
end

function clsNpc:GetRoleType() 
	return const.ROLE_TYPE.TP_NPC 
end
