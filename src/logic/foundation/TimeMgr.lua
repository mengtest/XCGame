---------------------
-- 游戏相关的时间管理
---------------------
ClsTimeManager = class("ClsTimeManager",clsCoreObject)
ClsTimeManager.__is_singleton = true

ClsTimeManager:RegisterEventType(const.TMR_LOTTERY_MONEY_ONCE)
ClsTimeManager:RegisterEventType(const.TMR_LOTTERY_DIAMOND_ONCE)

function ClsTimeManager:ctor()
	clsCoreObject.ctor(self)
	self.tAllTime = {}
	self.serverTime = -1
end

function ClsTimeManager:dtor()
	
end

function ClsTimeManager:SetRemainTime(timeId, remainSeconds)
	self:DestroyTimer(timeId)
	self.tAllTime[timeId] = remainSeconds
	
	redpoint.Triger("m_lottery")
	self:FireEvent(timeId, self.tAllTime[timeId])
	
	self:CreateAbsTimerLoop(timeId, 1, function()
		self.tAllTime[timeId] = self.tAllTime[timeId] - 1
		if self.tAllTime[timeId] < 0 then self.tAllTime[timeId] = 0 end
		self:FireEvent(timeId, self.tAllTime[timeId])
		if self.tAllTime[timeId] == 0 then 
			self:DestroyTimer(timeId) 
			redpoint.Triger("m_lottery")
		end
	end)
end

function ClsTimeManager:GetRemainTime(timeId)
	return self.tAllTime[timeId] or 0
end

function ClsTimeManager:GetServerTime()
	return self.serverTime
end

function ClsTimeManager:SyncServerTime(serTime)
	self.serverTime = serTime
end
