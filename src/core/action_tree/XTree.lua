-----------------
-- 动作树
-----------------
module("actree",package.seeall)

local CMD_TABLE = GetCmdTable()

local ST_XTREE_UNREADY = 1		--尚未构建
local ST_XTREE_READY = 2		--已构建
local ST_XTREE_PLAYING = 3		--播放中
local ST_XTREE_FINISHED = 4		--播放完毕
local ST_XTREE_STOPED = 5		--被强制停止

clsXTree = class("clsXTree")

function clsXTree:ctor()
	self.iCurState = ST_XTREE_UNREADY
	self.mRootNode = nil
	self.mXContext = clsXContext.new()
	self.tAllNodes = {}
end

function clsXTree:dtor()
	self:Stop()
	
	KE_SafeDelete(self.mRootNode)
	self.mRootNode = nil
	self.tAllNodes = {}
	
	KE_SafeDelete(self.mXContext)
	self.mXContext = nil
end

function clsXTree:GetXContext() 
	return self.mXContext 
end

function clsXTree:GetRoot()
	return self.mRootNode
end

function clsXTree:SetRoot(oXNode)
	assert(oXNode:IsRootNode())
	assert(not self.mRootNode, "已经设置了根节点")
	self.mRootNode = oXNode
	self.mXContext:SetAutoDelAtoms(oXNode:GetArgs().tAutoDelAtoms)
end

function clsXTree:IsPlaying()
	return self.iCurState == ST_XTREE_PLAYING
end

---------------------------------------------------------------

function clsXTree:Recover()
	assert(self.iCurState==ST_XTREE_FINISHED or self.iCurState==ST_XTREE_STOPED, "没事别乱Recover")
	self.mRootNode:RecoverAll()
	self.iCurState = ST_XTREE_READY
end

function clsXTree:Stop(OnStopSucc)
	assert(self.iCurState ~= ST_XTREE_UNREADY)
	assert(OnStopSucc==nil or type(OnStopSucc)=="function")
	
	if self:IsPlaying() then
		print("中断XTree")
		self.mRootNode:StopAll()
		
		local node_list = self.tAllNodes
		for _, node in pairs(node_list) do
			if not node:IsDead() then assert(false, "Stop出错，并未真的停下来") end
		end
		
		self.iCurState = ST_XTREE_STOPED
		
		self._finishCallback = nil
		if self._breakCallback then
			self._breakCallback()
			self._breakCallback = nil
		end
		
		if OnStopSucc then
			print("XTree中断回调")
			OnStopSucc()
		end
	end
end

function clsXTree:Play(finishCallback, breakCallback)
	if self.iCurState == ST_XTREE_PLAYING then 
		print("已经在播放中")
		return 
	end
	assert(self.iCurState == ST_XTREE_READY, "只能从ST_XTREE_READY切换到ST_XTREE_PLAYING")
	
	self.iCurState = ST_XTREE_PLAYING
	self._finishCallback = finishCallback
	self._breakCallback = breakCallback
	
	self.mRootNode:TryLaunch()
end

function clsXTree:Try2Finish()
	assert(self.iCurState ~= ST_XTREE_UNREADY)
	if self.iCurState == ST_XTREE_FINISHED or self.iCurState == ST_XTREE_STOPED then 
		return 
	end
	
	local node_list = self.tAllNodes
	for _, node in pairs(node_list) do
		if not node:IsPlayOvered() then
			return
		end
	end
	
	self.iCurState = ST_XTREE_FINISHED
	
	self._breakCallback = nil
	if self._finishCallback then
		self._finishCallback()
		self._finishCallback = nil
	end
end

---------------------------------------------------------------

-- 检测是否是有效的信息列表
-- 1. 检测孤岛，因为无法从根节点走到孤岛点，所以孤岛点是多余信息，而且会造成XTree永远无法播放完毕
-- 2. 检测环，如果存在环会导致死循环（有时候也许故意要循环）
function clsXTree:CheckValid(root_node, node_list)
	--检查是否存在环
	local bHasCircle = false
	local all_nodes = {}
	local func = function(oNode)
		if all_nodes[oNode] then
			if oNode:HasOffspring(oNode) then
				bHasCircle = true
				assert(false, "存在环: "..oNode:GetNodeType())
				return "break"
			end
		end
		all_nodes[oNode] = true
	end
	root_node:walk_all(func)
	
	if bHasCircle then
		return false 
	end
	
	--检查是否存在孤岛
	local cnt1, cnt2 = table.size(all_nodes), table.size(node_list)
	if cnt1 ~= cnt2 then
		local i = 0
		for id, node in pairs(node_list) do
			if not all_nodes[node] then
				i = i + 1
				print("孤岛"..i..": ", id)
			end
		end
		assert(false, string.format("存在%d个孤岛", cnt2-cnt1))
		return false 
	end
	
	return true
end

function clsXTree:BuildByInfo(info_list)
	assert(is_table(info_list))
	assert(not self.mRootNode, "已经构建")
	
	local xCtx = self.mXContext
	local root_node 
	local node_list = {}
	
	-- 创建所有节点
	for idx, xInfo in pairs(info_list) do
		local xunit_cls = CMD_TABLE[xInfo.cmdName]
		node_list[idx] = xunit_cls.new(xInfo.args, xCtx, self)
		
		if xInfo.cmdName == "x_root_node" then
			assert(root_node == nil, "Error: 只能存在一个根节点")
			root_node = node_list[idx]
		end
	end
	
	-- 将节点挂接起来
	for idx, xInfo in pairs(info_list) do
		for evtName, childList in pairs(xInfo.connectors) do
			for _, childIdx in ipairs(childList) do
				assert(node_list[idx], string.format("节点[%d]不存在，请检查配置：",idx))
				assert(node_list[childIdx], string.format("节点[%d]不存在，请检查配置：",childIdx))
				node_list[idx]:MountNode(node_list[childIdx], evtName, false)
			end
		end
	end
	
	if self:CheckValid(root_node, node_list) then
		self.tAllNodes = node_list
		self:SetRoot(root_node)
		self.iCurState = ST_XTREE_READY
	end
end

function clsXTree:SaveData(sPath)
	assert(sPath, "请输入存放路径")
	local node_list = self.tAllNodes
	local map_node_2_idx = {}
	for idx, node in pairs(node_list) do
		map_node_2_idx[node] = idx
	end
	
	local info_list = {}
	local func = function(oNode)
		local info = {
			["args"] = oNode:GetArgs(),
			["cmdName"] = oNode:GetNodeType(),
			["connectors"] = {},
		}
		
		oNode:foreach_all_subnodes(function(subNode, evtName)
			info.connectors[evtName] = info.connectors[evtName] or {}
			table.insert(info.connectors[evtName], map_node_2_idx[subNode])
		end)
		
		info_list[map_node_2_idx[oNode]] = info 
	end
	self.mRootNode:walk_all(func)
	
	table.save(info_list, sPath)
end
