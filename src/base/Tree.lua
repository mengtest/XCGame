---------------
-- 树结构
---------------
clsTreeNode = class("clsTreeNode")

function clsTreeNode:ctor(Id, Pid, Data)
	self._Id = Id
	self._Pid = Pid
	self._Data = Data
	self.Childrens = {}
end

function clsTreeNode:dtor()

end

function clsTreeNode:GetId()
	return self._Id
end

function clsTreeNode:GetPid()
	return self._Pid
end

function clsTreeNode:GetData()
	return self._Data
end

function clsTreeNode:GetChildList()
	return self.Childrens
end

function clsTreeNode:SetAttr(Key, Value)
	self[Key] = Value
end

function clsTreeNode:GetAttr(Key, Value)
	return self[Key]
end

------------------------------------------

clsTree = class("clsTree", clsCoreObject)

clsTree:RegisterEventType("ec_add_node")
clsTree:RegisterEventType("ec_del_node")
clsTree:RegisterEventType("ec_chg_nodeid")
clsTree:RegisterEventType("ec_update_nodedata")

function clsTree:ctor()
	clsCoreObject.ctor(self)
	self._AllNodes = {}
	self.Childrens = {}
end

function clsTree:dtor()
	self:DelAllNode()
end

function clsTree:IsEmpty() return table.is_empty(self.Childrens) end
function clsTree:GetNode(Id) return self._AllNodes[Id] end
function clsTree:GetChildList() return self.Childrens end

function clsTree:OnAddNode(Id, oTreeNode)
	
end

function clsTree:OnDelNode(Id)
	
end

function clsTree:OnNodeIdChanged(Id, NewId)

end

function clsTree:AddNode(Id, Pid, Data)
	if Pid ~= nil then assert(self._AllNodes[Pid], "父节点不存在："..Pid) end
	assert(Id ~= nil, "Id不可为空")
	assert(not self._AllNodes[Id], "已经添加过该节点："..Id)
	
	local oTreeNode = clsTreeNode.new(Id, Pid, Data)
	self._AllNodes[Id] = oTreeNode
	
	if Pid ~= nil then 
		table.insert(self._AllNodes[Pid].Childrens, oTreeNode)
	else
		table.insert(self.Childrens, oTreeNode)
	end
	
	self:OnAddNode(Id, oTreeNode)
	self:FireEvent("ec_add_node", Id, oTreeNode)
	
	return oTreeNode
end

function clsTree:DelNode(DelId)
	if DelId == nil then return end
	PreorderTraversal(self, function(CurNode, ParentNode, i)
		if CurNode._Id == DelId then
			--先删光子节点
			PostorderTraversal(self._AllNodes[DelId], function(CurDel, ParentOfCurDel, CurDelIdx)
				if ParentOfCurDel then
					local Id = CurDel._Id
					self._AllNodes[Id] = nil
					table.remove(ParentOfCurDel.Childrens, CurDelIdx)
					self:OnDelNode(Id)
					print("clsTree.DelNode", Id)
					self:FireEvent("ec_del_node", Id)
				end
			end)
			
			--再删自己
			self._AllNodes[DelId] = nil
			table.remove(ParentNode.Childrens, i)
			self:OnDelNode(DelId)
			print("clsTree.DelNode", DelId)
			self:FireEvent("ec_del_node", DelId)
			
			return "break"
		end
	end)
	
	self:CheckValid()
end

function clsTree:DelAllNode()
	local Len = #self.Childrens
	for i=Len,1,-1 do
		self:DelNode(self.Childrens[i]._Id)
	end
	self._AllNodes = {}
	self.Childrens = {}
end

function clsTree:ChgNodeId(Id, NewId)
	assert(NewId ~= nil, "新ID无效")
	if not self._AllNodes[Id] then return end
	if self._AllNodes[NewId] then return end
	local oTreeNode = self._AllNodes[Id]
	self._AllNodes[Id] = nil
	self._AllNodes[NewId] = oTreeNode
	oTreeNode._Id = NewId
	for _, ChildNode in ipairs(oTreeNode.Childrens) do
		ChildNode._Pid = NewId
	end
	self:OnNodeIdChanged(Id, NewId)
	self:FireEvent("ec_chg_nodeid", Id, NewId)
end

function clsTree:CheckValid()
	local idx = -1	--因为不计算自己在内
	PreorderTraversal(self, function(CurNode, ParentNode, i)
		idx = idx + 1
	end)
	print("检查树的有效性", idx)
	assert( table.size(self._AllNodes) == idx, string.format("BUG：数目不一致  %d : %d", idx, table.size(self._AllNodes)) )
end
