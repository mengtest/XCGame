module("ai",package.seeall)

local CmpFunc = {
	["lt"] = function(left,right) return left <  right end,
	["le"] = function(left,right) return left <= right end,
	["eq"] = function(left,right) return left == right end,
	["ge"] = function(left,right) return left >= right end,
	["gt"] = function(left,right) return left >  right end,
}
function AiCmp(sCmpType, leftValue, rightValue)
	return CmpFunc[sCmpType](leftValue, rightValue)
end


-- AI节点状态
BT_IDLE = 1
BT_RUNNING = "running"
BT_SUCCESS = true
BT_FAIL = false

-- AI事件
AI_EVENT = {
	START_COMBAT = 1,
	END_COMBAT = 2,
}

-- AI类型
AI_TYPE_NOTHING = 1				--什么都不做
AI_TYPE_ATTACK = 2				--攻击
AI_TYPE_TALK2NPC = 3			--与NPC对话
AI_TYPE_ZAZEN = 4				--打坐
AI_TYPE_COLLECT = 5				--采集
AI_TYPE_PASS = 6				--传送
AI_TYPE_TEMP = 7				--跨地图寻路临时传送
AI_TYPE_FIND_BOSS_ATTACK = 8	--攻击特定BOSS
AI_TYPE_DOUBLE_MOUNT = 9		--双人坐骑

-- 任务类型
BT_TASK_TYPE = {
	TASK_FIGHT = 1,
}

-- 任务状态
BT_TASK_STATE = {
	UNACCEPT = 0,	--未领取
	WAITING = 1,	--待执行
	RUNNING = 2,	--执行中
	SUCCESS = 3,	--执行成功
	FAIL = 4		--执行失败
}

-- 能否思考
function CanThink(theOwner)
	return not FORBIT_THINK_STATES[theOwner:GetActState()] 
end

function IsValidBtNodeState(v)
	return v==BT_RUNNING or v==BT_SUCCESS or v==BT_FAIL
end

function IsValidBtNodeResult(v)
	return v==BT_SUCCESS or v==BT_FAIL
end
