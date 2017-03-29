--------------------
-- 
--------------------
local TIP_TYPE = {
	TIP_ITEM = 1,
	TIP_SKILL = 2,
	TIP_ROLE = 3,
}

ClsTipsMgr = class("ClsTipsMgr", clsCoreObject)
ClsTipsMgr.__is_singleton = true

function ClsTipsMgr:ctor()
	clsCoreObject.ctor(self)
end

function ClsTipsMgr:dtor()
	
end

function ClsTipsMgr:ShowTipWnd(tipType, refNode, tContInfo)
	-- 关闭之前的窗口
	if self._CurTipWnd and not tolua.isnull(self._CurTipWnd) then
		ClsUIManager.GetInstance():DestroyWindowEx(self._CurTipWnd)
		self._CurTipWnd = nil 
	end
	
	-- 创建新窗口
	local wnd 
	
	if tipType == "TIP_ITEM" then
		local OnClickMask = function()
			ClsUIManager.GetInstance():DestroyWindow("clsTipsWndItem")
		end
		wnd = ClsUIManager.GetInstance():ShowTips("clsTipsWndItem", false, OnClickMask)
		
	elseif tipType == "TIP_SKILL" then
		local OnClickMask = function()
			ClsUIManager.GetInstance():DestroyWindow("clsTipsWndSkill")
		end
		wnd = ClsUIManager.GetInstance():ShowTips("clsTipsWndSkill", false, OnClickMask)
		
	elseif tipType == "TIP_ROLE" then
		local OnClickMask = function()
			ClsUIManager.GetInstance():DestroyWindow("clsTipsWndRole")
		end
		wnd = ClsUIManager.GetInstance():ShowTips("clsTipsWndRole", false, OnClickMask)
		
	else 
		assert(false, "未知的tipType")
	end
	
	-- 
	if wnd then
		wnd:UpdateContent(tContInfo)
		wnd:AddScriptHandler(const.CORE_EVENT.cleanup, function()
			self._CurTipWnd = nil 
		end)
	end
	
	self._CurTipWnd = wnd
end
