---------------------
-- 
---------------------
module("const", package.seeall)

-- 默认字体
local _DEF_FONT_CFG = {
	fontFilePath = "fonts/FZY4JW.TTF",  -- "fonts/SourceHanSansSC-Bold.otf",
	fontSize = 24,
	glyphs = cc.GLYPHCOLLECTION_DYNAMIC,
	customGlyphs = nil,
	distanceFieldEnabled = false,
	outlineSize = 0,
}
function DEF_FONT_CFG() return table.clone(_DEF_FONT_CFG) end
function DEF_FONT_CFG_REF() return _DEF_FONT_CFG end

--层定义
local ZORDER = 1
ORDER_MAP_LAYER 	= ZORDER 	ZORDER = ZORDER + 1		--地图层
ORDER_UI_LAYER 		= ZORDER 	ZORDER = ZORDER + 1		--UI层
ZORDER = 11		--地图层的子层
LAYER_LAND			= ZORDER	ZORDER = ZORDER + 1 	--陆地层
LAYER_OBJ			= ZORDER	ZORDER = ZORDER + 1 	--对象层
LAYER_WEATHER		= ZORDER	ZORDER = ZORDER + 1		--天气层
ZORDER = 21		--UI层的子层
LAYER_PANEL 		= ZORDER 	ZORDER = ZORDER + 1		--普通界面层
LAYER_POP			= ZORDER 	ZORDER = ZORDER + 1		--弹窗层
LAYER_DLG			= ZORDER 	ZORDER = ZORDER + 1		--模态对话框层
LAYER_TIPS 			= ZORDER 	ZORDER = ZORDER + 1		--Tips，通知，公告层
LAYER_GUIDE 		= ZORDER 	ZORDER = ZORDER + 1		--引导层
LAYER_CLICKEFF		= ZORDER 	ZORDER = ZORDER + 1		--点击特效层
LAYER_LOADING 		= ZORDER 	ZORDER = ZORDER + 1		---加载层
LAYER_WAITING		= ZORDER	ZORDER = ZORDER + 1		---转菊花层
LAYER_TOPEST		= ZORDER	ZORDER = ZORDER + 1		---顶层

-- 对象事件
CORE_EVENT = {
	EC_SHOW = "EC_SHOW",
	--
	["ec_touch_began"] = "ec_touch_began",
	["ec_touch_moved"] = "ec_touch_moved",
	["ec_touch_ended"] = "ec_touch_ended",
	["ec_touch_canceled"] = "ec_touch_canceled",
	--
	["enter"] = "enter",
	["enterTransitionFinish"] = "enterTransitionFinish",
	["exitTransitionStart"] = "exitTransitionStart",
	["exit"] = "exit",
	["cleanup"] = "cleanup",
}

-- 数字
NUMBER_CFG = { [0]="零", [1]="一", [2]="二", [3]="三", [4]="四", [5]="五", [6]="六", [7]="七", [8]="八", [9]="九", [10]="十" }
NUMBEREX_CFG = { [0]="零", [1]="壹", [2]="贰", [3]="叁", [4]="肆", [5]="伍", [6]="陆", [7]="柒", [8]="捌", [9]="玖", [10]="拾", [100]="佰", [1000]="仟", [10000]="万" }

-- 八方向
DIRECTION8 = {
	U 	= 1,		--上
	RU 	= 2,		--右上
	R 	= 3,		--右
	RD 	= 4,		--右下
	D 	= 5,		--下
	LD 	= 6,		--左下
	L 	= 7,		--左
	LU 	= 8,		--左上
}

