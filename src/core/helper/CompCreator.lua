module("helper",package.seeall)

local COMMON_APPLY_FUNC = {
	["tAnchorPt"] = function(NewComp, Attr)
		NewComp:setAnchorPoint(cc.p(Attr.tAnchorPt[1] or 0.5, Attr.tAnchorPt[2] or 0.5))
	end,
	["tPos"] = function(NewComp, Attr)
		local tPos = Attr.tPos
		local x = tPos[1] or 0
		local y = tPos[2] or 0
		if tPos.rx or tPos.ry then
			local parSize = NewComp:getParent():getContentSize()
			if tPos.rx then
				x = parSize.width - tPos.rx
			end
			if tPos.ry then
				y = parSize.height - tPos.ry 
			end
		end
		NewComp:setPosition(x,y)
	end,
	["tConSize"] = function(NewComp, Attr)
		NewComp:setContentSize(Attr.tConSize[1], Attr.tConSize[2]) 
	end,
	["iScale"] = function(NewComp, Attr) 
		if Attr.iScale~=1 then NewComp:setScale(Attr.iScale) end 
	end,
	["iScaleX"] = function(NewComp, Attr) 
		if Attr.iScaleX~=1 then NewComp:setScaleX(Attr.iScaleX) end 
	end,
	["iScaleY"] = function(NewComp, Attr) 
		if Attr.iScaleY~=1 then NewComp:setScaleY(Attr.iScaleY) end 
	end,
	["iRotate"] = function(NewComp, Attr) 
		if Attr.iRotate~=0 then NewComp:setRotation(Attr.iRotate) end 
	end,
	["iRotateX"] = function(NewComp, Attr) 
		if Attr.iRotateX~=0 then NewComp:setRotationX(Attr.iRotateX) end 
	end,
	["iRotateY"] = function(NewComp, Attr) 
		if Attr.iRotateY~=0 then NewComp:setRotationY(Attr.iRotateY) end 
	end,
	["iOpacity"] = function(NewComp, Attr) 
		if Attr.iOpacity~=255 then NewComp:setOpacity(Attr.iOpacity) end 
	end,
	["sAdaption"] = function(NewComp, Attr)
		if Attr.sAdaption.center then NewComp:SetToCenter() end
	end,
}

local SPEC_APPLY_FUNC = {
	["clsWindow"] = {
		["sTexNormal"] = function(NewComp, Attr) 
			NewComp:loadTexture(Attr.sTexNormal) 
		end,
	},
	["clsLayout"] = {
	
	},
	["clsButton"] = {
		["sTexNormal"] = function(NewComp, Attr) 
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:loadTextureNormal(Attr.sTexNormal or "") 
			end
		end,
		["sTexTouchDown"] = function(NewComp, Attr) 
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:loadTexturePressed(Attr.sTexTouchDown or "") 
			end
		end,
		["sTexDisable"] = function(NewComp, Attr) 
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:loadTextureDisabled(Attr.sTexDisable or "") 
			end
		end,
		["bScale9Enable"] = function(NewComp, Attr) 
			NewComp:setScale9Enabled(Attr.bScale9Enable) 
		end,
		["sTxt"] = function(NewComp, Attr) 
			NewComp:setTitleText(Attr.sTxt) 
		end,
		["iTitleFontSize"] = function(NewComp, Attr) 
			NewComp:setTitleFontSize(Attr.iTitleFontSize) 
		end,
		["TitleColor"] = function(NewComp, Attr) 
			NewComp:setTitleColor(Attr.TitleColor) 
		end,
		["tTitlePos"] = function(NewComp, Attr) 
			if NewComp:getTitleRenderer() then
				NewComp:getTitleRenderer():setPosition(Attr.tTitlePos[1], Attr.tTitlePos[2]) 
			end
		end,
	},
	["clsRadioButton"] = {
		["sTexSelected"] = function(NewComp, Attr) 
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:loadTextureBackGround(Attr.sTexSelected)
			end
		end,
		["sTexUnselected"] = function(NewComp, Attr) 
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:loadTextureFrontCross(Attr.sTexUnselected)
			end
		end,
	},
	["clsProgressBar"] = {
		["sTexNormal"] = function(NewComp, Attr) 
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:loadTexture(Attr.sTexNormal) 
			end
			NewComp:setDirection(ccui.LoadingBarDirection.LEFT) 
		end,
		["iPercentage"] = function(NewComp, Attr)
			NewComp:setPercent(Attr.iPercentage)
		end,
	},
	["clsSprite"] = {
		["sTexNormal"] = function(NewComp, Attr)  
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:setTexture(Attr.sTexNormal)
			end
		end,
	},
	["clsScale9Sprite"] = {
		["sTexNormal"] = function(NewComp, Attr)  
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:updateWithSprite(cc.Sprite:create(Attr.sTexNormal),cc.rect(0,0,0,0),false,NewComp:getCapInsets())
			end
		end,
		["CapInsets"] = function(NewComp, Attr) 
			NewComp:setCapInsets(Attr.CapInsets) 
		end,
	},
	["clsRichText"] = {
		["TextColor"] = function(NewComp, Attr) 
			NewComp:setTextColor( Attr.TextColor ) 
		end,
		["OutlineColor"] = function(NewComp, Attr) 
			NewComp:enableOutline(Attr.OutlineColor, 1) 
		end,
		["ShadowColor"] = function(NewComp, Attr) 
			NewComp:enableShadow(Attr.ShadowColor) 
		end,
		["GlowColor"] = function(NewComp, Attr) 
			NewComp:enableGlow(Attr.GlowColor) 
		end,
		["iMaxLineWidth"] = function(NewComp, Attr) 
			NewComp:setMaxLineWidth(Attr.iMaxLineWidth) 
		end,
		["iAlignment"] = function(NewComp, Attr) 
			NewComp:setAlignment(Attr.iAlignment) 
		end,
		["iFontSize"] = function(NewComp, Attr) 
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				local ttfcfg = NewComp:getTTFConfig()
				ttfcfg.fontSize = Attr.iFontSize
				NewComp:setTTFConfig(ttfcfg)
			end
		end,
		["sTxt"] = function(NewComp,Attr) 
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:setString(Attr.sTxt)
			end
		end,
	},
	["clsEditor"] = {
		["sTexNormal"] = function(NewComp, Attr)  
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				print("不能实时刷新显示纹理，因为没有改变纹理的接口")
			end
		end,
	},
	["clsItemWnd"] = {
		
	},
	["clsHeadWnd"] = {
		["iHeadId"] = function(NewComp, Attr)
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				NewComp:SetHeadId(Attr.iHeadId)
			end
		end,
		["iFrameStype"] = function(NewComp, Attr)
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then
				
			end
		end,
	},
	["clsCity"] = {
		["CityId"] = function(NewComp, Attr) 
			--在创建的时候已经应用了该属性
			if KE_IsEditMode() then 
				NewComp:SetUid(CityId)
			end
		end,
	},
	["clsCompnent"] = {
		["sFilePath"] = function(NewComp, Attr) 
			--在创建的时候已经应用了该属性
		end
	},
}

local CREATOR_FUNC = {
	["clsWindow"] = function(Attr, ParentNode) 
		return ui.clsWindow.new() 
	end,
	["clsLayout"] = function(Attr, ParentNode) 
		return ccui.Layout:create() 
	end,
	["clsButton"] = function(Attr, ParentNode) 
		return ccui.Button:create(Attr.sTexNormal, Attr.sTexTouchDown, Attr.sTexDisable) 
	end,
	["clsRadioButton"] = function(Attr, ParentNode) 
		return ccui.RadioButton:create(Attr.sTexUnselected, Attr.sTexSelected) 
	end,
	["clsProgressBar"] = function(Attr, ParentNode) 
		return ccui.LoadingBar:create(Attr.sTexNormal, Attr.iPercentage or 30) 
	end,
	["clsSprite"] = function(Attr, ParentNode) 
		return cc.Sprite:create(Attr.sTexNormal) or cc.Sprite:create("res/null.png")
	end,
	["clsScale9Sprite"] = function(Attr, ParentNode) 
		return cc.Scale9Sprite:create(Attr.sTexNormal) or cc.Scale9Sprite:create("res/null.png") 
	end,
	["clsRichText"] = function(Attr, ParentNode) 
		local fontcfg = const.DEF_FONT_CFG()
		fontcfg.fontSize = Attr.iFontSize or fontcfg.fontSize 
		return cc.Label:createWithTTF(fontcfg, Attr.sTxt or "") 
	--	return clsRichText.new(ParentNode, 100, 100, fontcfg.fontFilePath, fontcfg.fontSize)
	end,
	["clsEditor"] = function(Attr, ParentNode) 
		return ccui.EditBox:create(cc.size(Attr.tConSize[1],Attr.tConSize[2]),Attr.sTexNormal) 
	end,
	["clsItemWnd"] = function(Attr, ParentNode) 
		return ui.clsItemWnd.new(ParentNode) 
	end,
	["clsHeadWnd"] = function(Attr, ParentNode) 
		return ui.clsItemWnd.new(ParentNode, Attr.iHeadId, Attr.iFrameStype) 
	end,
	["clsCity"] = function(Attr, ParentNode) 
		return ui.clsCity.new(ParentNode, Attr.CityId) 
	end,
	["clsCompnent"] = function(Attr, ParentNode) 
		return ui.clsWindow.new(ParentNode, Attr.sFilePath) 
	end,
}

assert(table.has_same_key(CREATOR_FUNC, SPEC_APPLY_FUNC), "控件名须保持一一对应谢谢")

function IsValidControlType(ClassName)
	return CREATOR_FUNC[ClassName] ~= nil 
end

function CreateCompnent(CfgInfo, ParentNode)
	local ControlName = CfgInfo.Name
	local ClassName = CfgInfo.ClassName
	local Attr = CfgInfo.Attr
	local Childrens = CfgInfo.Childrens
	
	-- 创建
	local NewComp = CREATOR_FUNC[ClassName](Attr, ParentNode)
	assert(NewComp, string.format("创建控件失败: Name=%s, ClassName=%s", ControlName, ClassName))
	
	-- 读取属性
	ApplyCompnentAttr(NewComp, ClassName, Attr)
	
	return NewComp
end

function ApplyCompnentAttr(NewComp, ClassName, Attr)
	if not Attr then return end
	assert(NewComp, "不是有效的NewComp")
	assert(type(Attr)=="table", "参数类型不是table类型")
	for sKey, Value in pairs(Attr) do
		local ApplyFunc = COMMON_APPLY_FUNC[sKey] or SPEC_APPLY_FUNC[ClassName][sKey]
		assert(ApplyFunc, string.format("无效的属性应用接口：控件类型：%s，属性名称：%s",ClassName,sKey))
		ApplyFunc(NewComp, Attr)
	end
end

function GetTotalCompCntByFile(sCfgFile)
	if not sCfgFile then return 0 end
	local CfgInfo = setting.Get(sCfgFile)
	return GetTotalCompCntByInfo(CfgInfo)
end

function GetTotalCompCntByInfo(CfgInfo)
	if not CfgInfo then return 0 end
	local Cnt = 0
	local GetCount 
	GetCount = function(Info)
		if Info.Childrens then
			for _, subinfo in ipairs(Info.Childrens) do
				Cnt = Cnt + 1
				GetCount(subinfo)
			end
		end
	end
	GetCount(CfgInfo)
	return Cnt
end
