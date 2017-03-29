-------------
-- 主界面
-------------
module("ui", package.seeall)

clsFightPanel = class("clsFightPanel", clsWindow)

function clsFightPanel:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_battle/fight_panel.lua")
	
	utils.RegButtonEvent(self:GetCompByName("btn_exitfight"), function()
		fight.ClsFightSystem.GetInstance():RequestExit()
	end)
	
	utils.RegButtonEvent(self:GetCompByName("btn_autofight"), function()
		local opTarget = ClsRoleMgr.GetInstance():GetHero()
    	if opTarget then 
    		local objBtTask = opTarget:GetAiBrain():GetTaskById("fight_ai")
    		objBtTask:Pause(not objBtTask:IsPaused())
    	end
	end)
	
	utils.RegButtonEvent(self:GetCompByName("btn_jump"), function()
		local opTarget = ClsRoleMgr.GetInstance():GetHero()
	    if not opTarget then return end
		opTarget:CallJump(opTarget:getPositionX(),opTarget:getPositionY())
	end)
    
	local BtNameList = {"bt_attack_1","bt_attack_2","bt_attack_3","bt_attack_4","bt_attack_5","bt_attack_6",}
	for i=1,5 do
		utils.RegButtonEvent(self:GetCompByName(string.format("btn_skill%d",i)), function()
			local opTarget = ClsRoleMgr.GetInstance():GetHero()
			if not opTarget then return end

			if not opTarget:GetAiBrain():GetTaskById("fight_cmd_atk") then
				local objTask = ai.clsBtTask.new("fight_cmd_atk", BtNameList[i], opTarget, 0)
				opTarget:GetAiBrain():AddSerialTaskFirst(objTask)
			end
		end)
	end
	
	self:RefreshTimeStr("")
end

function clsFightPanel:dtor()

end

function clsFightPanel:RefreshBar(percent)
	self:GetCompByName("bar_timer"):setPercent(percent or 0)
end

function clsFightPanel:RefreshTimeStr(strTime)
	self:GetCompByName("label_time"):setString(strTime)
end
