--------------------
-- 辅助库
--------------------
module("utils", package.seeall)

function RegButtonEvent(Btn, OnClick)
	assert(Btn, "不是有效的按钮")
	assert(is_function(OnClick), "事件响应函数无效")
	local function touchEvent(sender, eventType)
		if eventType ~= ccui.TouchEventType.ended then return end 
		OnClick(sender)
	end
	Btn:addTouchEventListener(touchEvent)
end

function IsNodeRealyVisible(Node)
	if not Node then return false end
	while Node do
		if not Node:isVisible() then 
			return false 
		end
		Node = Node:getParent()
	end
	return true
end

-- 将srcObj转换到dstObj的局部空间
function ConvertSpace(dstObj, srcObj, x, y)
	x = x or 0 
	y = y or 0
	local Point = srcObj:convertToWorldSpace(cc.p(x, y))
	local Pt = dstObj:convertToNodeSpace(Point)
	return Pt
end

-- 将srcObj转换到dstObj的局部空间
function ConvertSpaceAR(dstObj, srcObj, x, y)
	x = x or 0 
	y = y or 0
	local Point = srcObj:convertToWorldSpaceAR(cc.p(x, y))
	local Pt = dstObj:convertToNodeSpace(Point)
	return Pt
end

function SetGray(obj, bGray)
	if not obj then return end
	
	if obj.setGLProgramState and obj.getGrayGLProgramState and obj.getNormalGLProgramState then 
		if bGray then
			obj:setGLProgramState(obj:getGrayGLProgramState())
		else
			obj:setGLProgramState(obj:getNormalGLProgramState())
		end
	end
	
	local child_list = obj:getChildren() or {}
	for _, ChildObj in pairs(child_list) do
		SetGray(ChildObj, bGray)
	end
end
