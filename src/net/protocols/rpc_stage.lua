----------------
-- 关卡协议
----------------
module("rpc", package.seeall)

c_stage_list = function(stage_list)
	for iStageType, iCurStageId in pairs(stage_list) do
		KE_Director:GetStageMgr():UpdateStageProgress(iStageType, iCurStageId)
	end
end
