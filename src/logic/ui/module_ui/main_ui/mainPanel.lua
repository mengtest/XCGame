------------------
-- 主界面
------------------
module("ui", package.seeall)

clsMainPanel = class("clsMainPanel", clsWindow)

function clsMainPanel:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_main/main_panel.lua")
	
	self.tFeatureBtns = {}
	
	self.mHeadWnd = clsHeadWnd.new(self:GetCompByName("head_node"), 1020005)
	utils.RegButtonEvent(self.mHeadWnd, function()
		ClsUIManager.GetInstance():ShowPopWnd("clsGMPanel", function()
			ClsUIManager.GetInstance():DestroyWindow("clsGMPanel")
		end)
	end)
	
	self.mGDPWnd = clsGDPWnd.new(self)
	
	self:InitFeatureBtns()
	self:RegisterRedButtons()
	
	self:GetCompByName("area4"):setVisible(false)
	utils.RegButtonEvent(self:GetCompByName("btn_challenge"), function()
		self:GetCompByName("area4"):setVisible(not self:GetCompByName("area4"):isVisible())
	end)
	
	local HeroData = KE_Director:GetHeroData()
	HeroData:AddListener(self, "sName", function()
		self:GetCompByName("LabelName"):setString(HeroData:GetsName())
	end, true)
	HeroData:AddListener(self, "iGrade", function()
		self:GetCompByName("LabelGrade"):setString(HeroData:GetiGrade())
	end, true)
	
--	guide:StartGuide(200) 
--	guide:StartGuide(100) 
--	ClsUIManager.GetInstance():ShowPopWnd("clsWhacAMole")
--	ClsUIManager.GetInstance():ShowPopWnd("clsTetrisView")
	--
--	self:TestRichText()
--[[
	KE_SetAbsTimeout(2, function() 
		ClsStoryPlayer.GetInstance():PlayStory("test_story_1", function() 
			guide:StartGuide(100) 
		end) 
	end)
]]
--	self:TestTree()
end

function clsMainPanel:dtor()
	local HeroData = KE_Director:GetHeroData()
	HeroData:DelListener(self)
	
	redpoint.RemoveRedButton(self:GetCompByName("btn_signin"))
	redpoint.RemoveRedButton(self:GetCompByName("btn_recruit"))
	redpoint.RemoveRedButton(self:GetCompByName("btn_lottery"))
	
	if self.mHeadWnd then KE_SafeDelete(self.mHeadWnd) self.mHeadWnd = nil end
	if self.mGDPWnd then KE_SafeDelete(self.mGDPWnd) self.mGDPWnd = nil end
end

function clsMainPanel:RegisterRedButtons()
	redpoint.RegisterRedButton("red_signin", self:GetCompByName("btn_signin"))
	redpoint.RegisterRedButton("red_recruit", self:GetCompByName("btn_recruit"))
	redpoint.RegisterRedButton("red_lottery", self:GetCompByName("btn_lottery"))
end

function clsMainPanel:CheckRegister(sSystemKey, Btn, ClickFunc)
	assert(setting.T_system_cfg[sSystemKey], "未配置的系统："..sSystemKey)
	assert(Btn, "不是有效的按钮")
	assert(is_function(ClickFunc), "ClickFunc必须为函数")
	if self.tFeatureBtns[sSystemKey] and self.tFeatureBtns[sSystemKey] ~= Btn then 
		assert(false, "重复注册相同的功能按钮")
		return false
	end
	for _, button in pairs(self.tFeatureBtns) do
		if button == Btn then
			assert(false, "该按钮已经被注册过")
			return false
		end
	end
	return true
end

function clsMainPanel:RegisterFeatureBtn(sSystemKey, Btn, ClickFunc)
	if not self:CheckRegister(sSystemKey, Btn, ClickFunc) then return end
	self.tFeatureBtns[sSystemKey] = Btn 
	utils.RegButtonEvent(Btn, ClickFunc)
	
	local GuideBtnName = string.format("主界面_%s",sSystemKey)
	guide:RegGuideBtn(GuideBtnName, Btn)
end

function clsMainPanel:GetFeatureBtn(sSystemKey)
	assert(setting.T_system_cfg[sSystemKey], "未配置的系统："..sSystemKey)
	return self.tFeatureBtns[sSystemKey]
end

function clsMainPanel:InitFeatureBtns()
	self:RegisterFeatureBtn("征途", self:GetCompByName("btn_journey"), function()
		ClsSystemMgr.GetInstance():EnterSystem("征途")
	end)
	self:RegisterFeatureBtn("背包", self:GetCompByName("btn_bag"), function()
		ClsSystemMgr.GetInstance():EnterSystem("背包")
	end)
	self:RegisterFeatureBtn("国家", self:GetCompByName("btn_country"), function()
		ClsSystemMgr.GetInstance():EnterSystem("国家")
	end)
	self:RegisterFeatureBtn("签到", self:GetCompByName("btn_signin"), function()
		ClsSystemMgr.GetInstance():EnterSystem("签到")
	end)
	self:RegisterFeatureBtn("邮件", self:GetCompByName("btn_email"), function()
		ClsSystemMgr.GetInstance():EnterSystem("邮件")
	end)
	self:RegisterFeatureBtn("好友", self:GetCompByName("btn_friend"), function()
		ClsSystemMgr.GetInstance():EnterSystem("好友")
	end)
	self:RegisterFeatureBtn("婚姻", self:GetCompByName("btn_marriage"), function()
		ClsSystemMgr.GetInstance():EnterSystem("婚姻")
	end)
	self:RegisterFeatureBtn("抽奖", self:GetCompByName("btn_lottery"), function()
		ClsSystemMgr.GetInstance():EnterSystem("抽奖")
	end)
	self:RegisterFeatureBtn("装备", self:GetCompByName("btn_equip"), function()
		ClsSystemMgr.GetInstance():EnterSystem("装备")
	end)
	self:RegisterFeatureBtn("融魂", self:GetCompByName("btn_soul"), function()
		ClsSystemMgr.GetInstance():EnterSystem("融魂")
	end)
	self:RegisterFeatureBtn("排行榜", self:GetCompByName("btn_ranklist"), function()
		ClsSystemMgr.GetInstance():EnterSystem("排行榜")
	end)
	self:RegisterFeatureBtn("竞技场", self:GetCompByName("btn_arena"), function()
		ClsSystemMgr.GetInstance():EnterSystem("竞技场")
	end)
	self:RegisterFeatureBtn("商店", self:GetCompByName("btn_shop"), function()
		ClsSystemMgr.GetInstance():EnterSystem("商店")
	end)
	self:RegisterFeatureBtn("比武招亲", self:GetCompByName("btn_wuzhao"), function()
		ClsSystemMgr.GetInstance():EnterSystem("比武招亲")
	end)
	self:RegisterFeatureBtn("圣物", self:GetCompByName("btn_relics"), function()
		ClsSystemMgr.GetInstance():EnterSystem("圣物")
	end)
	self:RegisterFeatureBtn("过关斩将", self:GetCompByName("btn_stage"), function()
		ClsSystemMgr.GetInstance():EnterSystem("过关斩将")
	end)
	self:RegisterFeatureBtn("招揽", self:GetCompByName("btn_recruit"), function()
		ClsSystemMgr.GetInstance():EnterSystem("招揽")
	end)
	self:RegisterFeatureBtn("切磋", self:GetCompByName("btn_qiecuo"), function()
		ClsSystemMgr.GetInstance():EnterSystem("切磋")
	end)
	self:RegisterFeatureBtn("擂台", self:GetCompByName("btn_leitai"), function()
		ClsSystemMgr.GetInstance():EnterSystem("擂台")
	end)
	self:RegisterFeatureBtn("充值", self:GetCompByName("btn_recharge"), function()
		ClsSystemMgr.GetInstance():EnterSystem("充值")
	end)
	self:RegisterFeatureBtn("VIP特权", self:GetCompByName("btn_vipright"), function()
		ClsSystemMgr.GetInstance():EnterSystem("VIP特权")
	end)
	self:RegisterFeatureBtn("首冲", self:GetCompByName("btn_firstrecharge"), function()
		ClsSystemMgr.GetInstance():EnterSystem("首冲")
	end)
	self:RegisterFeatureBtn("聊天", self:GetCompByName("BtnChat"), function()
		ClsSystemMgr.GetInstance():EnterSystem("聊天")
	end)

	--
	-- 玩法介绍 + 我要变强
--	self:RegisterFeatureBtn("攻略", self:GetCompByName("btn_helpdoc"), function()
--		ClsSystemMgr.GetInstance():EnterSystem("攻略")
--	end)
	-- 活动=永久活动+限时活动（节日礼包、生日礼包、等级礼包、七天登录礼包、许愿池）
end

--------------------------------------------

function clsMainPanel:TestRichText()
	local test_list = {
		"woshi#t()中国人#n()#c(ffaa22dd)我爱你#n#o(res/uiface/buttons/btn_yellow.png)VVVV#rddddddddd",
		"#o(res/icons/diamond.png)VVVVvvvv#o(item:1010102)#rddddddddd 我是一名Chinese人",
	}
	
	self.mRichText = clsRichText.new(self, 500,200)
	self:CreateTimerLoop("test_richtext", 60*1, function()
		local idx = math.random(1, #test_list)
		self.mRichText:setString( test_list[idx] )
	end)
end

function clsMainPanel:TestList()
	local compList = clsCompList.new(self, ccui.ScrollViewDir.vertical, 240, 400, 240, 70, "res/uiface/panels/list_common.png")
	compList:setPosition(0,-200)
	compList:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create("res/uiface/buttons/btn_blue.png", "res/uiface/buttons/btn_green.png")
		btn:setTitleText("我是"..CellObj:GetCellData())
		return btn
	end)
	
	for i=1, 26 do
		compList:Insert(i)
	end
	compList:ForceReLayout()
end

function clsMainPanel:TestTree()
	local CompTree = ui.clsCompTree.new(self,800,640,"res/mask_red.png")
	CompTree:setPosition(-400,-300)
	
	CompTree:AddNode("1_1")
	CompTree:AddNode("1_2")
	CompTree:AddNode("1_3")
	CompTree:AddNode("1_4")
	
	CompTree:AddNode("1_1_1", "1_1")
	CompTree:AddNode("1_1_2", "1_2")
	CompTree:AddNode("1_1_3", "1_3")
	CompTree:AddNode("1_1_4", "1_4")
	
	CompTree:AddNode("1_2_1", "1_2")
	CompTree:AddNode("1_2_2", "1_2")
	CompTree:AddNode("1_2_3", "1_2")
	CompTree:AddNode("1_2_4", "1_2")
	CompTree:AddNode("1_2_5", "1_2")
	CompTree:AddNode("1_2_6", "1_2")
	
	CompTree:AddNode("1_3_1", "1_3")
	CompTree:AddNode("1_3_2", "1_3")
	CompTree:AddNode("1_3_3", "1_3")
	CompTree:AddNode("1_3_4", "1_3")
	CompTree:AddNode("1_3_5", "1_3")
	
	CompTree:AddNode("1_1_3_1", "1_1_3")
	CompTree:AddNode("1_1_3_2", "1_1_3")
	CompTree:AddNode("1_1_3_3", "1_1_3")
	
end
