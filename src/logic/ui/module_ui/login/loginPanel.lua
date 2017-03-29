----------------
-- 登录界面
----------------
module("ui", package.seeall)

clsLoginPanel = class("clsLoginPanel", clsWindow)

function clsLoginPanel:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_login/login_panel.lua")
	
	self:init_widget_events()
	
	--
	local res_path = "effects/particle/skills/SmallSun.plist"
	utils.NewParticleSystemQuad(self, res_path, cc.POSITION_TYPE_GROUPED, nil, function()
		print("滴滴滴 销毁粒子", res_path)
	end)
	
	local res_path = "effects/effect_seq/skills/tornado1.plist"
	utils.NewSeqFrameEffect(self, res_path, 2, function()
		print("啊啊啊 销毁序列帧", res_path)
	end):setPosition(555,0)
end

function clsLoginPanel:dtor()

end

function clsLoginPanel:init_widget_events()
	--进入游戏按钮
	utils.RegButtonEvent(self:GetCompByName("btn_enter"), function()
		--[[
		local username = self:GetCompByName("usernameinput"):getText()
		local password = self:GetCompByName("pswdinput"):getText()
		if not username or username=="" then
			utils.TellMe("请输入用户名")
			return
		end
		if not password or password=="" then
			utils.TellMe("请输入密码")
			return
		end
		]]--
		network.SendPro("s_login", nil, "192.168.0.1", 9003, "gamer_1", "")
	end)
	
	-- 注册按钮
	self:GetCompByName("btn_zhuce"):setEnabled(false)
end

