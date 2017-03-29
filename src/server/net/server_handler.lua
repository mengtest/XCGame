--------------------
--[[
C2Lua::RegisterLuaFunc(L, "network", "SocketConnect", Lua_SocketConnet);
C2Lua::RegisterLuaFunc(L, "network", "SocketUpdate", Lua_SocketUpdate);
C2Lua::RegisterLuaFunc(L, "network", "SocketDisconnect", Lua_SocketDisconnect);

C2Lua::RegisterLuaFunc(L, "network", "SetSocketConnectFunc", Lua_SetSocketConnectFunc);
C2Lua::RegisterLuaFunc(L, "network", "SetSocketDisconnectFunc", Lua_SetSocketDisconnectFunc);
C2Lua::RegisterLuaFunc(L, "network", "SetSocketSucceedFunc", Lua_SetSocketSucceedFunc);

C2Lua::RegisterLuaFunc(L, "network", "AddTableFormat", Lua_AddTableFormat);
C2Lua::RegisterLuaFunc(L, "network", "AddProtocolFormat", Lua_AddProtocolFormat);
C2Lua::RegisterLuaFunc(L, "network", "ClearTableFormat", Lua_ClearTableFormat);
C2Lua::RegisterLuaFunc(L, "network", "ClearProtocolFormat", Lua_ClearProtocolFormat);
C2Lua::RegisterLuaFunc(L, "network", "GetProtocolCheckId", Lua_GetProtocolCheckId);
]]--
--------------------
module("server", package.seeall)

-------------
--
-------------
IsNetworkInited = false
ServerIp = -1
ServerPort = -1
IsConnected = false		--断线标记

-------------
--
-------------
local __HideProtocolPrint__ = {
	c_ping = 0, c_role_state = 0,
	s_ping = 0, s_lua_error = 0,
}

local __AllStructInfo__ = {}
local __AllProtocolInfo__ = {}

function GetTblInfo(self, Name)
	return __AllStructInfo__[Name]
end

function GetProtocolInfo(self, Name)
	return __AllProtocolInfo__[Name]
end

local OutPrint = function (...)
	local s = {}
	for _, v in ipairs({...}) do
		if type(v) == "table" then
			s[#s+1] = string.format("table[%d] \t", table.size(v))
		else
			s[#s+1] = string.format("%s \t", tostring(v))
		end
	end
	print(table.concat(s))
end

local function PackComplex(def, argI)
	local PackFunc 
	PackFunc = function(def, argI)
		local StructDef = __AllStructInfo__[def[2]]
		
		if def[3] == 0 then
			--是数组
			assert(table.is_array(argI),"argI应该为数组")
			local ElementDef = { [2]=def[2] }
			for _, value in ipairs(argI) do
				PackFunc(ElementDef, value)
			end
		elseif def[3] ~= nil then
			--是哈希表
			local ElementDef = {[2]=def[2]}
			for key, value in pairs(argI) do
				assert(type(key) == def[3], "键类型必须为："..def[3].."，而非"..type(key))
				PackFunc(ElementDef, value)
			end
		elseif StructDef then
			--是结构体
			if table.size(argI) ~= #StructDef then
				--table.print(argI)  table.print(StructDef)
				local tmptbl = {}
				for _, tmpinfo in ipairs(StructDef) do
					tmptbl[ tmpinfo[1] ] = true
				end
				
				for tmpkey, _ in pairs(argI) do
					if not tmptbl[tmpkey] then
						print("协议中未规定字段：", tmpkey)
					end
				end
				for tmpkey, _ in pairs(tmptbl) do
					if not argI[tmpkey] then
						print("缺少字段：", tmpkey)
					end
				end
				assert( false, string.format("%s 字段数不符：当前为：%d,  应该为：%d",StructDef[2],table.size(argI),table.size(StructDef)) )
			end
			for i, field in ipairs(StructDef) do
				assert( argI[ field[1] ], "缺少字段："..field[1] )
				PackFunc( field, argI[ field[1] ] )
			end
		else 
			--是基础类型
			assert( type(argI) == def[2], string.format("类型不符：传入类型为%s  要求类型为%s",type(argI),def[2]) )
		end
	end
	
	PackFunc(def, argI)
end

-- 基本类型：数字:number (int8 int16 int32 int64 float)  字符串:string(注意转UTF8) 
-- 复合类型：数组:array  哈希表:hashtbl  结构体:struct
local function CheckPtoArgs(ArgsConf, arglist)
	assert(#arglist==#ArgsConf, string.format("参数个数不对, 应该为：%d, 当前为：%d", #ArgsConf, #arglist))
	for i, def in ipairs(ArgsConf) do
		PackComplex(def, arglist[i])
	end
end

-------------
--
-------------
-- 初始化协议
local function InitNetworkProtocol()
	__AllStructInfo__ = {}
	__AllProtocolInfo__ = {}
	
	local info = io.SafeLoadFile("src/data/protocal_define/allpto.lua")
	local StructList, ProtoList = info[1], info[2]
	assert(table.is_array(StructList), "结构体列表有误")
	assert(table.is_array(ProtoList), "协议列表有误")
	
	for _, StructConf in ipairs(StructList) do
		local Name, Conf = unpack(StructConf)
		__AllStructInfo__[Name] = Conf
--		server.AddTableFormat(Name, Conf)
	end
	
	for PtoPid, PtoConf in ipairs(ProtoList) do
		local Name, Conf = unpack(PtoConf)
		__AllProtocolInfo__[PtoPid] = {
			["Conf"] = Conf,
			["PtoName"] = Name,
			["PtoPid"] = PtoPid,
		}
		
		local PtoPrint = __HideProtocolPrint__[Name] and function () end or OutPrint
		
		if string.sub(Name, 1, 2) == "c_" then
			--生成客户端协议
			server[Name] = function(...)
				PtoPrint(string.format("[S-->C %s]",Name), ...)
				--检查参数是否合法
				local arglist = {...}
				CheckPtoArgs(__AllProtocolInfo__[PtoPid].Conf, arglist)
				--生成网络数据包
				local SocketPkt = {PtoPid, ...}
				--发送
				SendPkt(SocketPkt)
			end
--			_G.for_caller[Name] = server.AddProtocolFormat(Name, Conf, Callback)
		else
			--生成服务端协议
			assert( server[Name], string.format("该协议尚未实现: %s",Name) )
		end
	end
end

-- 发送数据包
function SendPkt(pkt)
	network.OnPacket(pkt)
end

-- 收到数据包
function OnPacket(pkt)
	local func_id = pkt[1]
	local func_name = __AllProtocolInfo__[func_id].PtoName
	local userid = KE_Director:GetHeroId()
	pkt[1] = userid
	
	--处理
	print( string.format("[S:RECIEVE] %s", func_name) )
	server[func_name](unpack(pkt))
end


-------------------------------------------------------------

--协议发送成功的回调
local function OnSendSucceed(SendPid)
	
end

local function OnSendFailed(SendPid)

end

-- 停止从网络缓存读取数据
function StopSocketTimer()
	if server.m_SocketTimer then
		server.m_SocketTimer:Stop()
		server.m_SocketTimer = nil
	end
end
-- 开始从网络缓存读取数据
function StartSocketTimer()
	server.m_SocketTimer = delaycall_loop(0, server.SocketUpdate)
end

--启动网络
function Start(self)
	if IsNetworkInited then return end
	IsNetworkInited = true
	InitNetworkProtocol()
--	server.SetSocketSucceedFunc( OnSendSucceed )					--设置协议发送成功的回调
--	server.SetSocketConnectFunc( OnConnected )						--设置连接成功的回调
--	server.SetSocketDisconnectFunc( OnDisconnected )				--设置断线的回调
--	server.SocketConnect(ServerIp, ServerPort)						--连接
--	self.m_SocketTimer = delaycall_loop(0, server.SocketUpdate)	--开始从网络缓存读取数据
--	ccprint("连接服务器 …… …… ", ServerIp, ServerPort)
end


