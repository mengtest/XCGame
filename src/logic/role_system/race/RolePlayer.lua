------------------
-- 其他玩家
------------------
clsPlayer = class("clsPlayer", clsRole)

-- 构造函数
function clsPlayer:ctor(iUid, TypeId)
	clsRole.ctor(self, iUid, TypeId)
end

--析构函数
function clsPlayer:dtor()
	
end

function clsPlayer:GetRoleType() 
	return const.ROLE_TYPE.TP_PLAYER 
end
