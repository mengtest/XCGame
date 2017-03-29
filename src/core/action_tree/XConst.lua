----------------------
-- actree模块相关常量定义
----------------------
module("actree",package.seeall)

XEventEnum = {
	ec_xstart  = "ec_xstart",
	ec_xfinish = "ec_xfinish",
}

function IsValidXNodeEvtName(evtName)
	-- 第0帧就触发的事件点挂到到ec_xstart上
	if evtName==XEventEnum.ec_xstart or evtName==XEventEnum.ec_xfinish then return true end
	if is_number(evtName) and evtName > 0 then return true end
	return false
end
