-------------------
-- 节点基类
-- 事件点触发顺序：XEventEnum.ec_xstart ---> 1, 4, 5, ... ---> XEventEnum.ec_xfinish
-- 理论上事件点的触发顺序应该严格按照上面所示的顺序。
-- 但是由于一些不可控的因素，逻辑上处理成了允许ec_xfinish在【1, 4, 5, ...】之前触发
-------------------
module("actree",package.seeall)

local ST_XNODE_READY 	= 1		--未启动
local ST_XNODE_RUNNING 	= 2		--运行中
local ST_XNODE_FINISHED = 3		--播放完毕
local ST_XNODE_STOPED 	= 4		--被强制停止

local is_empty_tbl = table.is_empty

clsXNode = class("clsXNode")

function clsXNode:ctor(args, xCtx, oXTree)
	assert(args, "Error：没设置播放参数")
	assert(xCtx, "Error: 没有设置上下文")
	assert(oXTree, "Error: 没有设置所属树")
	
	xCtx:MarkAtomId(args.atom_id) 
	
	self._node_type = "un_known"
	self._tArgs = args
	self._mXContext = xCtx
	self._mXTree = oXTree
	self.tSubNodes = {}			--子节点列表
	
	--随状态变化而变化的一些变量
	self._curState = ST_XNODE_READY
	self._wait_count = 0
	self.trigger_handlers = {}	--除ec_xstart和ec_xfinish之外的事件通过Timer来触发
	
	self._origin_wait_cnt = 0
end

function clsXNode:dtor()
	self:StopSelf()
	self:ClearSubNodes()
end

function clsXNode:ClearSubNodes()
	self:foreach_all_subnodes(function(oXNode)
		KE_SafeDelete(oXNode)
	end)
	self.tSubNodes = {}
end

function clsXNode:GetNodeType() return self._node_type end
function clsXNode:GetArgs() return self._tArgs end
function clsXNode:GetXContext() return self._mXContext end
function clsXNode:GetXTree() return self.mXTree end
function clsXNode:IsRootNode() return self._node_type == "x_root_node" end


function clsXNode:IsFinished()
	return self._curState == ST_XNODE_FINISHED
end
function clsXNode:IsAllPointLaunched()
	return is_empty_tbl(self.trigger_handlers)
end
function clsXNode:IsStoped() 
	return self._curState == ST_XNODE_STOPED
end
function clsXNode:IsPlayOvered()
	return self._curState == ST_XNODE_FINISHED and is_empty_tbl(self.trigger_handlers)
end
function clsXNode:IsDead()
	return self._curState == ST_XNODE_STOPED or self:IsPlayOvered()
end
function clsXNode:IsRunning()
	return self._curState == ST_XNODE_RUNNING
end

----------------------------------------------------------------

function clsXNode:OnStop()

end

function clsXNode:StopSelf()
	if self._curState ~= ST_XNODE_FINISHED then
		self._curState = ST_XNODE_STOPED
	end
	
	for _, tmID in pairs(self.trigger_handlers) do
		KE_KillTimer(tmID)
	end
	self.trigger_handlers = {}
	
	self:OnStop()
end

function clsXNode:StopAll()
	self:StopSelf()
	
	self:foreach_all_subnodes(function(oXNode)
		oXNode:StopAll()
	end)
end

function clsXNode:RecoverSelf()
	assert(self:IsDead(), "未停止之前，不可调用该接口")
	self._curState = ST_XNODE_READY
	self._wait_count = self._origin_wait_cnt
	self.trigger_handlers = {}
end

function clsXNode:RecoverAll()
	self:RecoverSelf()
	
	self:foreach_all_subnodes(function(oXNode)
		oXNode:RecoverAll()
	end)
end

---------------------------------------------------------------

-- evtName表示在本节点launch后第几帧触发oNode
-- force_list在该事件触发时马上启动oNode
-- weak_list: 当有多个节点指向oNode时，需要所有这些节点都触发了oNode才启动oNode
function clsXNode:MountNode(oNode, evtName, bForceLaunch)
	assert(oNode, "挂了一个非法节点")
	assert(IsValidXNodeEvtName(evtName), "非法的挂接点"..evtName)
	assert(self._curState == ST_XNODE_READY, "不可在非准备状态下挂接子节点")
	
	self.tSubNodes[evtName] = self.tSubNodes[evtName] or { 
			["force_list"] = {}, 
			["weak_list"]  = {}, }
	
	local insert_list = bForceLaunch and self.tSubNodes[evtName].force_list or self.tSubNodes[evtName].weak_list
	table.insert(insert_list, oNode)
	
	if not bForceLaunch then
		oNode:_IncWaitCount()
	end
end

function clsXNode:_IncWaitCount()
	self._wait_count = self._wait_count + 1
	self._origin_wait_cnt = math.max(self._origin_wait_cnt, self._wait_count)
end

function clsXNode:_DecWaitCount()
	self._wait_count = self._wait_count - 1
	if self._wait_count <= 0 then
		self:Launch()
	end
end

-- 尝试启动
function clsXNode:TryLaunch()
	self:_DecWaitCount()
end

-- 立即启动
function clsXNode:Launch()
	if self._curState == ST_XNODE_RUNNING then
		print(string.format("%s: 已经在运行中",self._node_type))
		return
	end
	assert(self._curState == ST_XNODE_READY, "只能从ST_XNODE_READY转换到ST_XNODE_RUNNING")
	self._curState = ST_XNODE_RUNNING
--	log_warn("启动节点: ",self._node_type)
	self:Proc(self._tArgs, self._mXContext)
end

function clsXNode:Proc(args, xCtx)
	assert(false, "子类请重载")
	--self:on_event_point(XEventEnum.ec_xstart)
	--self:trigger_user_events()					-- ec_xstart和ec_xfinish之外的事件点的触发通过Timer
	--self:on_event_point(XEventEnum.ec_xfinish)	-- finish事件需要到具体的动作节点中才能确定
end

-- 除ec_xstart和ec_xfinish之外的事件通过Timer来触发（基于帧）
function clsXNode:trigger_user_events()
	if self:IsStoped() then
		log_warn( string.format("%s触发失败，节点已Stop", self._node_type) )
		return
	end
	
	for iFrame, _ in pairs(self.tSubNodes) do
		if iFrame ~= XEventEnum.ec_xstart and iFrame ~= XEventEnum.ec_xfinish then
			KE_KillTimer(self.trigger_handlers[iFrame])
			self.trigger_handlers[iFrame] = KE_SetTimeout(iFrame, function()
				self.trigger_handlers[iFrame] = nil
				self:on_event_point(iFrame)
			end)
		end
	end
end

-- 触发mount到该事件点的所有subNodes
function clsXNode:on_event_point(evtName)
	if self:IsStoped() then
		log_warn("已停止", self._node_type, evtName)
		return
	end
--	print("【on_event_point】", self._node_type, evtName)
	
	-- 强启动列表
	self:foreach_subnodes_on_event(evtName, true,  function(oXNode)
		oXNode:Launch()
	end)
	-- 弱启动列表
	self:foreach_subnodes_on_event(evtName, false, function(oXNode)
		oXNode:TryLaunch()
	end)
	
	if evtName == XEventEnum.ec_xfinish then
		self._curState = ST_XNODE_FINISHED
		
		if not self:IsAllPointLaunched() then
			print("【warning】触发点在ec_xfinish事件之后！！！")
		end
	end
	
	if self:IsDead() then
		self._mXTree:Try2Finish()
	end
end

------------------------------------------------------

function clsXNode:foreach_subnodes_on_event(evtName, isForceList, func)
	if not self.tSubNodes or not self.tSubNodes[evtName] then return end
	
	local iter_list = isForceList and self.tSubNodes[evtName].force_list or self.tSubNodes[evtName].weak_list
	for i, oXNode in ipairs(iter_list) do
		func(oXNode)
	end
end

function clsXNode:foreach_all_subnodes(func)
	if not self.tSubNodes then return end
	
	for evtName, _ in pairs(self.tSubNodes) do
		self:foreach_subnodes_on_event(evtName, true, function(oXNode)
			func(oXNode, evtName)
		end)

		self:foreach_subnodes_on_event(evtName, false, function(oXNode)
			func(oXNode, evtName)
		end)
	end
end

function clsXNode:walk_all(func)
	if func(self) == "break" then return end
	
	self:foreach_all_subnodes(function(oXNode, evtName)
		oXNode:walk_all(func)
	end)
end

-- 判断oXNode是否是我的后代节点
function clsXNode:HasOffspring(oXNode)
	local tAllSprings = {}
	self:_MarkOffspring(tAllSprings)
	return tAllSprings[oXNode] == true
end

function clsXNode:_MarkOffspring(tAllSprings)
	self:foreach_all_subnodes(function(oXNode, evtName)
		if tAllSprings[oXNode] then return end
		tAllSprings[oXNode] = true
		oXNode:_MarkOffspring(tAllSprings)
	end)
end

