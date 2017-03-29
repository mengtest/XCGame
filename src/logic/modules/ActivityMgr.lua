----------------
-- 活动管理器
----------------
clsActivityManager = class("clsActivityManager", clsCoreObject)
clsActivityManager.__is_singleton = true

clsActivityManager:RegisterEventType("open_act")
clsActivityManager:RegisterEventType("close_act")
clsActivityManager:RegisterEventType("update_act")

function clsActivityManager:ctor()
	clsCoreObject.ctor(self)
	self.tAllAct = {}
end

function clsActivityManager:dtor()

end

-- ActInfo = { ActId=1, ActName="", StartTime=1, EndTime=1 }
function clsActivityManager:OpenActivity(ActId, ActInfo)
	ActInfo.ActId = ActId
	self.tAllAct[ActId] = ActInfo
	self:FireEvent("open_act", ActId, ActInfo)
end

function clsActivityManager:CloseActivity(ActId)
	self.tAllAct[ActId] = nil
	self:FireEvent("close_act", ActId)
end

function clsActivityManager:UpdateActivity(ActId, NewInfo)
	local ActInfo = self.tAllAct[ActId]
	assert(ActInfo, "不存在该活动："..ActId)
	for k,v in pairs(NewInfo) do
		ActInfo[k] = v
	end
	self:FireEvent("update_act")
end


----------------------- getter ------------------------
function clsActivityManager:GetActInfo(ActId)
	return self.tAllAct[ActId]
end

function clsActivityManager:GetActInfoByName(ActName)
	for _, ActInfo in pairs(self.tAllAct) do
		if ActInfo.Name == ActName then
			return ActInfo
		end
	end
	return nil 
end

function clsActivityManager:GetActNameById(ActId)
	return self.tAllAct[ActId] and self.tAllAct[ActId].ActName
end

function clsActivityManager:GetActIdByName(ActName)
	local ActInfo = self:GetActInfoByName(ActName)
	return ActInfo and ActInfo.ActName
end

function clsActivityManager:GetActOpenTime(ActId)
	if not self.tAllAct[ActId] then return end
	local ActInfo = self.tAllAct[ActId]
	return ActInfo.StartTime, ActInfo.EndTime
end
