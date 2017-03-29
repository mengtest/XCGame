------------------
-- 通用界面
------------------
module("ui", package.seeall)

clsCommonFrame = class("clsCommonFrame", clsWindow)

function clsCommonFrame:ctor(parent, sUIfilePath, sTitleName, funcOnCloseBtn)
	assert(sUIfilePath, "须传入UI配置文件")
	clsWindow.ctor(self, parent, sUIfilePath)
	-- 设置标题
	self:SetViewTitle(sTitleName or "")
	-- 关闭按钮
	self:SetCloseFunc(funcOnCloseBtn or function() self:Close() end)
end

function clsCommonFrame:SetViewTitle(sTitleName)
	self:GetCompByName("normal_frame"):GetCompByName("label_title"):setString(sTitleName)
end

function clsCommonFrame:SetCloseFunc(funcOnCloseBtn)
	utils.RegButtonEvent(self:GetCompByName("normal_frame"):GetCompByName("btn_close"), funcOnCloseBtn)
end

function clsCommonFrame:dtor()
	
end
