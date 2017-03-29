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
module("network", package.seeall)

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
--		network.AddTableFormat(Name, Conf)
	end
	
	for PtoPid, PtoConf in ipairs(ProtoList) do
		local Name, Conf = unpack(PtoConf)
		__AllProtocolInfo__[PtoPid] = {
			["Conf"] = Conf,
			["PtoName"] = Name,
			["PtoPid"] = PtoPid,
		}
		
		local PtoPrint = __HideProtocolPrint__[Name] and function () end or OutPrint
		
		if string.sub(Name, 1, 2) == "s_" then
			--生成服务端协议
			rpc[Name] = function(...)
				PtoPrint(string.format("[C-->S %s]",Name), ...)
				--检查参数是否合法
				local arglist = {...}
				CheckPtoArgs(__AllProtocolInfo__[PtoPid].Conf, arglist)
				--生成网络数据包
				local SocketPkt = {PtoPid, ...}
				--发送
				SendPkt(SocketPkt)
				--
				FireGlobalEvent("SEND_PTO", Name)
			end
--			_G.for_caller[Name] = network.AddProtocolFormat(Name, Conf, Callback)
		else
			--生成客户端协议
			assert( rpc[Name], string.format("该协议尚未实现: %s",Name) )
		end
	end
end

local m_PtoQueue = clsQueue.new()
local m_ProcessList = clsQueue.new()

-- 发送数据包
function SendPkt(pkt)
	server.OnPacket(pkt)
end

-- 收到数据包
function OnPacket(pkt)
	local func_id = pkt[1]		-- RecievePtoPid
	local func_name = __AllProtocolInfo__[func_id].PtoName	--RecievePtoName
	table.remove(pkt,1)
	local Args = pkt
	local RecieveCallback
	
	--弹出队列
	local FirstElement = m_PtoQueue:GetFirstElement()
	if FirstElement and PROTOCAL_PAIR[FirstElement.SendPtoName] then
		--收到对应的返回协议或者通用失败协议时出队
		RecieveCallback = FirstElement.RecieveCallback
		if PROTOCAL_PAIR[FirstElement.SendPtoName][func_name] or ERROR_PTO_LIST[func_name] then
			m_PtoQueue:Pop()
			print(string.format("协议出队：%s", FirstElement.SendPtoName))
		end
	end
	
	if not __HideProtocolPrint__[func_name] then
		print( string.format("[C:RECIEVE] %s", func_name) )
	end
	
	--处理协议（加入到待处理列表中，防止每帧处理的协议数过多导致卡帧）
	m_ProcessList:Push({func_name, Args, RecieveCallback})
	ProcessPro()
end

local m_TmrProcess = false
function ProcessPro()
	if m_TmrProcess then return end
	m_TmrProcess = KE_SetInterval(1, function()
		for i=1, 16 do 
			local Info = m_ProcessList:Pop()
			if not Info then 
				m_TmrProcess = false
				return true
			end
			
			local func_name, Args, RecieveCallback = Info[1], Info[2], Info[3]
			assert(rpc[func_name], "未实现协议："..func_name)
			rpc[func_name](unpack(Args))
			if RecieveCallback then RecieveCallback() end
			FireGlobalEvent("RECIEVE_PTO", func_name)
		end
	end)
end

-- 发送协议的统一化接口
function SendPro(SendPtoName, RecieveCallback, ...)
	assert(is_nil(RecieveCallback) or is_function(RecieveCallback))
	
	--加入队列
	if PROTOCAL_PAIR[SendPtoName] then
		local send_info = {
			["SendPtoName"] = SendPtoName,
			["RecieveCallback"] = RecieveCallback,
			["Args"] = {...},
		}
		m_PtoQueue:Push(send_info)
		print(string.format("协议入队：%s", SendPtoName))
	else
		assert(RecieveCallback == nil, "非重连协议不可以有协议回调")
	end
	
	--发送
	rpc[SendPtoName](...)
end


-------------------------------------------------------------

-- 连接成功回调
local function OnConnected(Ip, Port)
	print("成功连接到服务器 ... ...", Ip, Port)
	ServerIp = Ip
	ServerPort = Port
	IsConnected = true
	FireGlobalEvent("NETEVENT_CONNECTED")
end

-- 断线回调
local function OnDisconnected(SendPid)
	IsConnected = false
	print("断线了 ！！！ ！！！")
	FireGlobalEvent("NETEVENT_DISCONNECTED")
end

--协议发送成功的回调
local function OnSendSucceed(SendPid)
	
end

-- 停止从网络缓存读取数据
function StopSocketTimer()
	if network.m_SocketTimer then
		network.m_SocketTimer:Stop()
		network.m_SocketTimer = nil
	end
end

-- 开始从网络缓存读取数据
function StartSocketTimer()
	network.m_SocketTimer = delaycall_loop(0, network.SocketUpdate)
end

--重连
function StartReconnect()
	if not IsConnected then
		print(string.format("[SocketReConnect] Ip = %s, Port = %d", ServerIp, ServerPort))
		network.SocketConnect(ServerIp, ServerPort)
	end
end

--断连
function StopReconnect()
	IsConnected = false
	network.SocketDisconnect()
end

--启动网络
function Start(self)
	if IsNetworkInited then return end
	IsNetworkInited = true
	InitNetworkProtocol()
--	network.SetSocketSucceedFunc( OnSendSucceed )					--设置协议发送成功的回调
--	network.SetSocketConnectFunc( OnConnected )						--设置连接成功的回调
--	network.SetSocketDisconnectFunc( OnDisconnected )				--设置断线的回调
--	network.SocketConnect(ServerIp, ServerPort)						--连接
--	self.m_SocketTimer = delaycall_loop(0, network.SocketUpdate)	--开始从网络缓存读取数据
--	ccprint("连接服务器 …… …… ", ServerIp, ServerPort)
end
