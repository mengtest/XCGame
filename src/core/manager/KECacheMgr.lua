-----------------------
-- 本地缓存管理
-----------------------
module("cache", package.seeall)

local m_WritablePath = device.writablePath .. LOCAL_DIR
local m_PrivatePath

function GetWritablePath()
	return m_WritablePath
end

function GetPrivatePath()
	m_PrivatePath = m_PrivatePath or m_WritablePath.."/client/"..KE_Director:GetHeroId().."/"
	return m_PrivatePath
end

ClsCacheMgr = class("ClsCacheMgr")
ClsCacheMgr.__is_singleton = true

function ClsCacheMgr:ctor()
	
end

function ClsCacheMgr:dtor()
    
end


print("++++++++++++++++++++++++")
print(GetWritablePath())
print("++++++++++++++++++++++++")

