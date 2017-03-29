----------------
-- 宣传推荐管理器
----------------
local bEnablePop = false 

ClsAdvertiseManager = class("ClsAdvertiseManager", clsCoreObject)
ClsAdvertiseManager.__is_singleton = true

function ClsAdvertiseManager:ctor()
	clsCoreObject.ctor(self)
	self.bHasCheckLoginAdver = false
end

function ClsAdvertiseManager:dtor()

end

--登录宣传
function ClsAdvertiseManager:CheckLoginAdver()
	if not bEnablePop then return end 
	if self.bHasCheckLoginAdver then return end
	self.bHasCheckLoginAdver = true
	
	for _, info in ipairs(setting.T_advertise) do
		if info.login_checker() then
			local procedure_1 
			procedure_1 = procedure.clsProcedure.new(function() 
					print("登录宣传", info.Id, info.ImgPath)
					local AdverWnd = ClsUIManager.GetInstance():ShowTips("clsAdvertisePanel", true, function()
						ClsUIManager.GetInstance():DestroyWindow("clsAdvertisePanel")
						procedure_1:OnEnd()
					end) 
					AdverWnd:SetAdverInfo(info, 1)
			end)
			procedure_1:SetBindScene("rest_scene")
			KE_Director:GetProcedureMgr():PushBack(procedure_1)
		end
	end
end

-- 条件宣传
function ClsAdvertiseManager:CheckSpecAdver()
	if not bEnablePop then return end 
	if not self.bHasCheckLoginAdver then return end
	
	self._HistoryList = self._HistoryList or {}		--只弹一次
	
	for _, info in ipairs(setting.T_advertise) do
		if not self._HistoryList[info.Id] and info.spec_checker() then
			self._HistoryList[info.Id] = true 
			
			local procedure_1 
			procedure_1 = procedure.clsProcedure.new(
				function() 
					print("条件宣传", info.Id, info.ImgPath)
					local AdverWnd = ClsUIManager.GetInstance():ShowTips("clsAdvertisePanel", true, function()
						ClsUIManager.GetInstance():DestroyWindow("clsAdvertisePanel")
						procedure_1:OnEnd()
					end) 
					AdverWnd:SetAdverInfo(info, 2)
				end,
				function()
					ClsUIManager.GetInstance():DestroyWindow("clsAdvertisePanel")
				end
			)
			procedure_1:SetBindScene("rest_scene")
			KE_Director:GetProcedureMgr():PushBack(procedure_1)
			
			break
		end
	end
end
