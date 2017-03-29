------------------
-- 建国界面
------------------
module("ui", package.seeall)

clsCountryBuildWnd = class("clsCountryBuildWnd", clsWindow)

function clsCountryBuildWnd:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_country/country_build.lua")
	self:setPosition(GAME_CONFIG.DESIGN_W_2, GAME_CONFIG.DESIGN_H_2+100)
	
	self:InitFlagList()

	utils.RegButtonEvent(self:GetCompByName("btn_close"), function()
		self:Show(false)
	end)
	
	utils.RegButtonEvent(self:GetCompByName("btn_ok"), function()
		if self._funOk then 
			local str = self:GetCompByName("editorinput"):getText()
			if not str or str=="" then 
				utils.TellMe("请输入国名")
				return
			end
			if not self._FlagId then
				utils.TellMe("请选择旗帜")
				return
			end
			self._funOk(str, self._FlagId)
		end
		self:Show(false)
	end)
end

function clsCountryBuildWnd:dtor()
	if self.mCompList then KE_SafeDelete(self.mCompList) self.mCompList = nil end
end

function clsCountryBuildWnd:Refresh(FuncOnOk)
	self._funOk = FuncOnOk
end

function clsCountryBuildWnd:InitFlagList()
	if self.mCompList then return end
	self.mCompList = clsCompList.new(self, ccui.ScrollViewDir.horizontal, 800, 172, 148, 165, "res/uiface/panels/dividing_dark.png")
	local compList = self.mCompList
	compList:setPosition(self:getContentSize().width/2-400,-175)
	compList:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create(CellObj:GetCellData().respath, CellObj:GetCellData().respath)
		return btn
	end)
	compList:AddListener("lis_click_cell", "ec_click_cell", function(CellObj)
		self:SetFlagId(CellObj:GetCellId())
	end)
	
	for flagid, info in pairs(setting.T_flag_cfg) do
		compList:Insert(info, flagid)
	end
	compList:ForceReLayout()
end

function clsCountryBuildWnd:SetFlagId(flagid)
	self._FlagId = flagid
end
