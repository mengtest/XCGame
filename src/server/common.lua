-------------
--
-------------
module("server", package.seeall)

local m_WritablePath = device.writablePath .. LOCAL_DIR
local m_PrivatePath

function GetServerWritablePath()
	return m_WritablePath
end

function GetServerPrivatePath()
	m_PrivatePath = m_PrivatePath or m_WritablePath.."/server/1000000001"
	return m_PrivatePath
end
