------------------
-- 征途界面
------------------
module("ui", package.seeall)

clsJourneyPanel = class("clsJourneyPanel", clsWindow)

function clsJourneyPanel:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_journey/journey_panel.lua")
	
	self.mGDPWnd = clsGDPWnd.new(self)

	utils.RegButtonEvent(self:GetCompByName("btn_back"), function()
		ClsSceneMgr.GetInstance():Turn2Scene("rest_scene")
	end)
end

function clsJourneyPanel:dtor()
	if self.mGDPWnd then KE_SafeDelete(self.mGDPWnd) self.mGDPWnd = nil end
end
