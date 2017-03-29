----------------
-- 关卡管理器
----------------
clsStageManager = class("clsStageManager", clsCoreObject)
clsStageManager.__is_singleton = true

clsStageManager:RegisterEventType("e_stage_progress")

function clsStageManager:ctor()
	clsCoreObject.ctor(self)
	self.tProgressInfo = {
		[const.STAGE_NORMAL] = 0,
		[const.STAGE_HARD] = 0,
		[const.STAGE_PURGATORY] = 0,
	}
end

function clsStageManager:dtor()
	
end

function clsStageManager:UpdateStageProgress(iStageType, iCurStageId)
	self.tProgressInfo[iStageType] = iCurStageId
	self:FireEvent("e_stage_progress", iStageType, iCurStageId)
end

function clsStageManager:GetStageProgress(iStageType)
	return self.tProgressInfo[iStageType]
end

function clsStageManager:HasPassedStage(iStageId)
	local StageInfo = setting.GetStageInfoById(iStageId)
	local StageType = StageInfo.StageType
	return iStageId <= self.tProgressInfo[StageType]
end
