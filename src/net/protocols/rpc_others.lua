-----------------
-- 其他协议
-----------------
module("rpc", package.seeall)

-- 请求
c_tell_fail = function(msg)
	utils.TellMe(msg)
end

c_notice = function(msg)
	utils.TellNotice(msg)
end

c_show_panel = function(panel_name, params)
	ClsUIManager.GetInstance():ShowPanel(panel_name, params)
end

c_show_dialog = function(dlg_name, params)
	ClsUIManager.GetInstance():ShowDialog(dlg_name, params)
end
