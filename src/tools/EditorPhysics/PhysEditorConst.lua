-----------------
-- 物理编辑器
-----------------
module("editorphys", package.seeall)

MIN_AGENT_SIZE = 16

-- 工具栏
ALL_CONTROLS = {
	["clsCircle"] 		= "圆形",
	["clsRect"] 		= "矩形",
	["clsSegment"] 		= "线段",
	["clsPolygon"] 		= "多边形",
	["clsSector"] 		= "扇形",
}

-- 属性栏
COMMON_ATTR = {
	{ PropName = "iPosX", 			Desc = "位置X", 		PropType = "float" },
	{ PropName = "iPosY", 			Desc = "位置Y",			PropType = "float" },
	{ PropName = "iMass", 			Desc = "质量",			PropType = "float" },
	{ PropName = "iDensity", 		Desc = "密度", 			PropType = "float" },
	{ PropName = "iElasticity", 	Desc = "弹力", 			PropType = "float" },
	{ PropName = "iFriction", 		Desc = "摩擦力", 		PropType = "float" },
	{ PropName = "bMovable", 		Desc = "可否移动", 		PropType = "boolean" },
	{ PropName = "bGravitable", 	Desc = "受重力影响否", 	PropType = "boolean" },
	{ PropName = "iGravity", 		Desc = "重力加速度", 	PropType = "float" },
}
SPEC_ATTR = {
	["clsCircle"] = {
		{ PropName = "iRadius", 	Desc = "半径", 		PropType = "float" },
	},
	["clsRect"] = {
		{ PropName = "iWidth", 		Desc = "宽度", 		PropType = "float" },
		{ PropName = "iHeight", 	Desc = "高度", 		PropType = "float" },
	},
	["clsSegment"] = {
		{ PropName = "tExtremityA", Desc = "端点1", 	PropType = "point" },
		{ PropName = "tExtremityB", Desc = "端点2", 	PropType = "point" },
	},
	["clsPolygon"] = {
		{ PropName = "tPtList", 	Desc = "点序列", 	PropType = "string" },
	},
	["clsSector"] = {
		{ PropName = "iInnerRadius", Desc = "内半径", 		PropType = "float" },
		{ PropName = "iOuterRadius", Desc = "外半径", 		PropType = "float" },
		{ PropName = "iFromAngle", 	 Desc = "起始角度", 	PropType = "float" },
		{ PropName = "iToAngle", 	 Desc = "终止角度", 	PropType = "float" },
	},
}

-- 有些控件在创建时一些属性不可为空，在这里提供默认值
DEFAULT_ATTR = {
	
}

-- 属性数据变化监听器
-- Setter: 根据编辑框的输入，更新数据
-- Getter: 根据数据，刷新属性栏
COMMON_ATTR_FUNC = {
	["iPosX"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iPosX = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iPosX 
			return ValueStr
		end,
	},
	["iPosY"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iPosY = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iPosY 
			return ValueStr
		end,
	},
	["iMass"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iMass = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iMass 
			return ValueStr
		end,
	},
	["iDensity"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iDensity = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iDensity
			return ValueStr
		end,
	},
	["iElasticity"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iElasticity = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iElasticity
			return ValueStr
		end,
	},
	["iFriction"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iFriction = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iFriction
			return ValueStr
		end,
	},
	["bMovable"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr=="是" and true or false
			oTreeNode:GetData().Attr.bMovable = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.bMovable and "是" or "否"
			return ValueStr
		end,
	},
	["bGravitable"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = ValueStr=="是" and true or false
			oTreeNode:GetData().Attr.bGravitable = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.bGravitable and "是" or "否"
			return ValueStr
		end,
	},
	["iGravity"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iGravity = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iGravity
			return ValueStr
		end,
	},
}
SPEC_ATTR_FUNC = {
	["iRadius"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iRadius = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iRadius
			return ValueStr
		end,
	},
	["iWidth"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iWidth = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iWidth
			return ValueStr
		end,
	},
	["iHeight"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iHeight = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iHeight
			return ValueStr
		end,
	},
	["tExtremityA"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = loadstring(ValueStr)
			oTreeNode:GetData().Attr.tExtremityA = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = table.get_table_str( oTreeNode:GetData().Attr.tExtremityA )
			return ValueStr
		end,
	},
	["tExtremityB"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = loadstring(ValueStr)
			oTreeNode:GetData().Attr.tExtremityB = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = table.get_table_str( oTreeNode:GetData().Attr.tExtremityB )
			return ValueStr
		end,
	},
	["tPtList"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = loadstring(ValueStr)
			oTreeNode:GetData().Attr.tPtList = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = table.get_table_str( oTreeNode:GetData().Attr.tPtList )
			return ValueStr
		end,
	},
	["iInnerRadius"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iInnerRadius = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iInnerRadius
			return ValueStr
		end,
	},
	["iOuterRadius"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iOuterRadius = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iOuterRadius
			return ValueStr
		end,
	},
	["iFromAngle"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iFromAngle = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iFromAngle
			return ValueStr
		end,
	},
	["iToAngle"] = {
		Setter = function(CtrlName, oTreeNode, ValueStr)
			local vv = tonumber(ValueStr)
			oTreeNode:GetData().Attr.iToAngle = vv
			return vv
		end,
		Getter = function(CtrlName, oTreeNode)
			local ValueStr = oTreeNode:GetData().Attr.iToAngle
			return ValueStr
		end,
	},
}
