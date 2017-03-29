-----------------
-- UI编辑器
-----------------
module("editorui", package.seeall)

MIN_AGENT_SIZE = 16

-- 工具栏
ALL_CONTROLS = {
	["clsWindow"] 		= "窗口",
	["clsLayout"] 		= "控件",
	["clsButton"] 		= "按钮",
	["clsRadioButton"] 	= "单选按钮",
	["clsProgressBar"] 	= "进度条",
	["clsSprite"] 		= "精灵",
	["clsScale9Sprite"] = "九宫格精灵",
	["clsRichText"] 	= "富文本",
	["clsEditor"] 		= "输入框",
	["clsItemWnd"] 		= "物品框",
	["clsCompnent"] 	= "外部文件",
}

-- 属性栏
COMMON_ATTR = {
	{ PropName = "tAnchorPt", 	Desc = "锚点", 		PropType = "point" },
	{ PropName = "tPos", 		Desc = "位置",		PropType = "point" },
	{ PropName = "tConSize", 	Desc = "尺寸",		PropType = "point" },
	{ PropName = "iScale", 		Desc = "缩放", 		PropType = "float" },
	{ PropName = "iScaleX", 	Desc = "X缩放", 	PropType = "float" },
	{ PropName = "iScaleY", 	Desc = "Y缩放", 	PropType = "float" },
	{ PropName = "iRotate", 	Desc = "旋转", 		PropType = "float" },
	{ PropName = "iRotateX", 	Desc = "X旋转", 	PropType = "float" },
	{ PropName = "iRotateY", 	Desc = "Y旋转", 	PropType = "float" },
	{ PropName = "iOpacity", 	Desc = "透明度", 	PropType = "int" },
}
SPEC_ATTR = {
	["clsWindow"] = {
		{ PropName = "sTexNormal", 	Desc = "纹理", PropType = "image" },
	},
	["clsLayout"] = {
		
	},
	["clsButton"] = {
		{ PropName = "sTexNormal", 		Desc = "纹理_普通状态", 	PropType = "image" },
		{ PropName = "sTexTouchDown", 	Desc = "纹理_按下状态", 	PropType = "image" },
		{ PropName = "sTexDisable", 	Desc = "纹理_禁用状态",		PropType = "image" },
		{ PropName = "bScale9Enable", 	Desc = "是否九宫模式",		PropType = "boolean" },
		{ PropName = "sTxt", 			Desc = "标题",				PropType = "string" },
		{ PropName = "iTitleFontSize", 	Desc = "标题字体大小", 		PropType = "int" },
		{ PropName = "TitleColor", 		Desc = "标题颜色",			PropType = "color" },
		{ PropName = "tTitlePos", 		Desc = "标题位置", 			PropType = "point" },
	},
	["clsRadioButton"] = {
		{ PropName = "sTexSelected", 	Desc = "纹理_选中状态", 	PropType = "image" },
		{ PropName = "sTexUnselected", 	Desc = "纹理_未选中状态", 	PropType = "image" },
	},
	["clsProgressBar"] = {
		{ PropName = "sTexNormal", 		Desc = "纹理_普通状态", 	PropType = "image" },
		{ PropName = "iPercentage",		Desc = "百分比",			PropType = "int" },
	},
	["clsSprite"] = {
		{ PropName = "sTexNormal", 		Desc = "纹理_普通状态", 	PropType = "image" },
	},
	["clsScale9Sprite"] = {
		{ PropName = "sTexNormal", 		Desc = "纹理", 				PropType = "image" },
		{ PropName = "CapInsets", 		Desc = "九宫区域", 			PropType = "string" },
	},
	["clsRichText"] = {
		{ PropName = "TextColor", 		Desc = "文本颜色",			PropType = "color" },
		{ PropName = "OutlineColor", 	Desc = "包边颜色",			PropType = "color" },
		{ PropName = "ShadowColor", 	Desc = "阴影颜色",			PropType = "color" },
		{ PropName = "GlowColor", 		Desc = "流光颜色",			PropType = "color" },
		{ PropName = "iMaxLineWidth",	Desc = "最大宽度", 			PropType = "int" },
		{ PropName = "iAlignment", 		Desc = "对齐方式", 			PropType = "int" },
		{ PropName = "iFontSize", 		Desc = "字体大小", 			PropType = "int" },
		{ PropName = "sTxt", 			Desc = "文本内容",			PropType = "string" },
	},
	["clsEditor"] = {
		{ PropName = "sTexNormal", 		Desc = "纹理", 				PropType = "image" },
	},
	["clsItemWnd"] = {
		
	},
	["clsCompnent"] = {
		{ PropName = "sFilePath", 		Desc = "外部组件路径",		PropType = "string" },
	},
}

-- 有些控件在创建时一些属性不可为空，在这里提供默认值
DEFAULT_ATTR = {
	["clsEditor"] = {
		tConSize = {150,28},
	},
	["clsProgressBar"] = {
		sTexNormal = "res/null.png",
		iPercentage = 30,
	},
	["clsSprite"] = {
		sTexNormal = "res/null.png",
	},
	["clsScale9Sprite"] = {
		sTexNormal = "res/null.png",
	},
}

-- 属性数据变化监听器
-- Setter: 根据编辑框的输入，更新数据
-- Getter: 根据数据，刷新属性栏
COMMON_ATTR_FUNC = {
	["tAnchorPt"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local info = string.split(ValueStr,",")
			local x,y = tonumber(info[1]) or 0.5, tonumber(info[2]) or 0.5
			local vv = {x,y}
			oTreeNode:GetData().Attr.tAnchorPt = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local tAnchorPt = oTreeNode:GetData().Attr.tAnchorPt 
			if not tAnchorPt then return "" end
			return string.format("%d,%d",tAnchorPt[1],tAnchorPt[2])
		end,
	},
	["tPos"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local info = string.split(ValueStr,",")
			local x,y = tonumber(info[1]) or 0, tonumber(info[2]) or 0
			local vv = {x,y}
			oTreeNode:GetData().Attr.tPos = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local tPos = oTreeNode:GetData().Attr.tPos 
			if not tPos then return "" end
			return string.format("%d,%d",tPos[1],tPos[2])
		end,
	},
	["tConSize"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local info = string.split(ValueStr,",")
			local w,h = tonumber(info[1]) or 0, tonumber(info[2]) or 0
			local vv = {w,h}
			oTreeNode:GetData().Attr.tConSize = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local tConSize = oTreeNode:GetData().Attr.tConSize 
			if not tConSize then return "" end
			return string.format("%d,%d",tConSize[1],tConSize[2])
		end,
	},
	["iScale"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr) or 1
			oTreeNode:GetData().Attr.iScale = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iScale or ""
		end,
	},
	["iScaleX"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr) or 1
			oTreeNode:GetData().Attr.iScaleX = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iScaleX or ""
		end,
	},
	["iScaleY"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr) or 1
			oTreeNode:GetData().Attr.iScaleY = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iScaleY or ""
		end,
	},
	["iRotate"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr) or 1
			oTreeNode:GetData().Attr.iRotate = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iRotate or ""
		end,
	},
	["iRotateX"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr) or 1
			oTreeNode:GetData().Attr.iRotateX = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iRotateX or ""
		end,
	},
	["iRotateY"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr) or 1
			oTreeNode:GetData().Attr.iRotateY = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iRotateY or ""
		end,
	},
	["iOpacity"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr) or 255
			oTreeNode:GetData().Attr.iOpacity = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iOpacity or ""
		end,
	},
}
SPEC_ATTR_FUNC = {
	["sTexNormal"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr
			oTreeNode:GetData().Attr.sTexNormal = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.sTexNormal or ""
		end,
	},
	["sTexTouchDown"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr
			oTreeNode:GetData().Attr.sTexTouchDown = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.sTexTouchDown or ""
		end,
	},
	["sTexDisable"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr
			oTreeNode:GetData().Attr.sTexDisable = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.sTexDisable or ""
		end,
	},
	["sTexUnselected"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr
			oTreeNode:GetData().Attr.sTexUnselected = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.sTexUnselected or ""
		end,
	},
	["sTexSelected"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr
			oTreeNode:GetData().Attr.sTexSelected = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.sTexSelected or ""
		end,
	},
	["TextColor"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local a,r,g,b = math.Hex2ARGB(ValueStr)
			vv = cc.c3b(r,g,b)
			oTreeNode:GetData().Attr.TextColor = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			if not oTreeNode:GetData().Attr.TextColor then return "" end
			return math.ARGB2Hex( oTreeNode:GetData().Attr.TextColor )
		end,
	},
	["OutlineColor"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local a,r,g,b = math.Hex2ARGB(ValueStr)
			vv = cc.c4b(r,g,b,a)
			oTreeNode:GetData().Attr.OutlineColor = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			if not oTreeNode:GetData().Attr.OutlineColor then return "" end
			return math.ARGB2Hex( oTreeNode:GetData().Attr.OutlineColor )
		end,
	},
	["ShadowColor"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local a,r,g,b = math.Hex2ARGB(ValueStr)
			vv = cc.c4b(r,g,b,a)
			oTreeNode:GetData().Attr.ShadowColor = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			if not oTreeNode:GetData().Attr.ShadowColor then return "" end
			return math.ARGB2Hex( oTreeNode:GetData().Attr.ShadowColor )
		end,
	},
	["GlowColor"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local a,r,g,b = math.Hex2ARGB(ValueStr)
			vv = cc.c4b(r,g,b,a)
			oTreeNode:GetData().Attr.GlowColor = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			if not oTreeNode:GetData().Attr.GlowColor then return "" end
			return math.ARGB2Hex( oTreeNode:GetData().Attr.GlowColor )
		end,
	},
	["iMaxLineWidth"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iMaxLineWidth = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iMaxLineWidth or ""
		end,
	},
	["iAlignment"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iAlignment = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iAlignment or ""
		end,
	},
	["iFontSize"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iFontSize = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iFontSize or ""
		end,
	},
	["sTxt"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr
			oTreeNode:GetData().Attr.sTxt = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.sTxt or ""
		end,
	},
	["bScale9Enable"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr=="是" and true or false
			oTreeNode:GetData().Attr.bScale9Enable = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.bScale9Enable and "是" or "否"
		end,
	},
	["iTitleFontSize"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iTitleFontSize = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iTitleFontSize or ""
		end,
	},
	["TitleColor"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local a,r,g,b = math.Hex2ARGB(ValueStr)
			local vv = cc.c3b( r,g,b )
			oTreeNode:GetData().Attr.TitleColor = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			if not oTreeNode:GetData().Attr.TitleColor then return "" end
			return math.ARGB2Hex( oTreeNode:GetData().Attr.TitleColor )
		end,
	},
	["tTitlePos"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local info = string.split(ValueStr,",")
			local x,y = tonumber(info[1]) or 0, tonumber(info[2]) or 0
			local vv = {x,y}
			oTreeNode:GetData().Attr.tTitlePos = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local tTitlePos = oTreeNode:GetData().Attr.tTitlePos
			if not tTitlePos or table.is_empty(tTitlePos) then return "" end
			return string.format("%d,%d", tTitlePos[1] or 0, tTitlePos[2] or 0)
		end,
	},
	["sFilePath"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr
			oTreeNode:GetData().Attr.sFilePath = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.sFilePath or ""
		end,
	},
	["CapInsets"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local info = string.split(ValueStr,",")
			local x,y,w,h = info[1], info[2], info[3], info[4]
			if not (x and y and w and h) then 
				utils.TellMe("CapInsets格式不正确: "..value)
				return 
			end
			local vv = { x = x, y = y, width = w, height = h }
			oTreeNode:GetData().Attr.CapInsets = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local CapInsets = oTreeNode:GetData().Attr.CapInsets
			if not CapInsets or table.is_empty(CapInsets) then return "" end
			return string.format("%d,%d,%d,%d", CapInsets.x, CapInsets.y, CapInsets.width, CapInsets.height)
		end,
	},
	["iPercentage"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iPercentage = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			return oTreeNode:GetData().Attr.iPercentage or ""
		end,
	},
}
