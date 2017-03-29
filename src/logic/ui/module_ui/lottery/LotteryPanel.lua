------------------
-- 抽奖界面
------------------
module("ui", package.seeall)

clsLotteryBox1 = class("clsLotteryBox1", clsWindow)

function clsLotteryBox1:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_lottery/lottery_box_1.lua")
	
	utils.RegButtonEvent(self:GetCompByName("btn_once"), function()
		if KE_Director:GetTimeMgr():GetRemainTime(const.TMR_LOTTERY_MONEY_ONCE) <= 0 then
			utils.TellMe("免费抽一次")
			KE_Director:GetTimeMgr():SetRemainTime(const.TMR_LOTTERY_MONEY_ONCE, 60*10)
		else
			utils.TellMe("抽一次")
		end
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_ten"), function()
		utils.TellMe("抽十次")
	end)
	
	local InstTimeMgr = KE_Director:GetTimeMgr()
	InstTimeMgr:AddListener(self, const.TMR_LOTTERY_MONEY_ONCE, function(timeId, LeftSeconds)
		local strTime = "免费"
		if InstTimeMgr:GetRemainTime(const.TMR_LOTTERY_MONEY_ONCE) > 0 then
			strTime = libtime.ChangeSToH( InstTimeMgr:GetRemainTime(const.TMR_LOTTERY_MONEY_ONCE) )
			strTime = string.format("%s后免费",strTime)
		end
		self:GetCompByName("label_time"):setString(strTime)
	end, true)
end

function clsLotteryBox1:dtor()
	KE_Director:GetTimeMgr():DelListener(self)
end

clsLotteryBox2 = class("clsLotteryBox2", clsWindow)

function clsLotteryBox2:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_lottery/lottery_box_2.lua")
	
	utils.RegButtonEvent(self:GetCompByName("btn_once"), function()
		if KE_Director:GetTimeMgr():GetRemainTime(const.TMR_LOTTERY_DIAMOND_ONCE) <= 0 then
			utils.TellMe("免费抽一次")
			KE_Director:GetTimeMgr():SetRemainTime(const.TMR_LOTTERY_DIAMOND_ONCE, 60*60*24)
		else
			utils.TellMe("抽一次")
		end
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_ten"), function()
		utils.TellMe("抽十次")
	end)
	
	local InstTimeMgr = KE_Director:GetTimeMgr()
	InstTimeMgr:AddListener(self, const.TMR_LOTTERY_DIAMOND_ONCE, function(timeId, LeftSeconds)
		local strTime = "免费"
		if InstTimeMgr:GetRemainTime(const.TMR_LOTTERY_DIAMOND_ONCE) > 0 then
			strTime = libtime.ChangeSToH( InstTimeMgr:GetRemainTime(const.TMR_LOTTERY_DIAMOND_ONCE) )
			strTime = string.format("%s后免费",strTime)
		end
		self:GetCompByName("label_time"):setString(strTime)
	end, true)
end

function clsLotteryBox2:dtor()
	KE_Director:GetTimeMgr():DelListener(self)
end

--------------------------------------------------------------------

clsLotteryPanel = class("clsLotteryPanel", clsCommonFrame)

function clsLotteryPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_lottery/lottery_panel.lua", "抽奖")
	
	local SelfSize = self:getContentSize()
	self._BoxList = { clsLotteryBox1.new(self), clsLotteryBox2.new(self), }
	local BeginX = -#self._BoxList/2 * 420 + 210 + SelfSize.width/2
	local Y = SelfSize.height/2-28
	for i=1, #self._BoxList do
		self._BoxList[i]:setPosition(BeginX+420*(i-1),Y)
	end
end

function clsLotteryPanel:dtor()
	for _, Box in ipairs(self._BoxList) do
		KE_SafeDelete(Box)
	end
	self._BoxList = {}
end
