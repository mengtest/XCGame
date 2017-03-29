------------------
-- 美人界面
------------------
module("ui", package.seeall)

clsBeautyPanel = class("clsBeautyPanel", clsCommonFrame)

function clsBeautyPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_country/beauty_panel.lua", "美人")
	
	self:InitBeautyList()
end

function clsBeautyPanel:dtor()
	if self.mCompBeautyList then KE_SafeDelete(self.mCompBeautyList) self.mCompBeautyList=nil end
end

function clsBeautyPanel:InitBeautyList()
	if self.mCompBeautyList then return self.mCompBeautyList end
	
	local ICON_SIZE = 274
	local LIST_WID = GAME_CONFIG.VIEW_W-10
	local LIST_HEI = ICON_SIZE+20
	
	self.mCompBeautyList = clsCompList.new(self:GetCompByName("beautyarea"), ccui.ScrollViewDir.horizontal, LIST_WID, LIST_HEI, ICON_SIZE+8, LIST_HEI)
	local compList = self.mCompBeautyList
	compList:setPosition(-LIST_WID/2, 0)
	
	compList.HighLightSelectComp = function(this, Comp, bHighLight)
		if not Comp then return end
		
		if bHighLight then
			if not Comp._ListHighLightSpr then 
				Comp._ListHighLightSpr = cc.DrawNode:create()
				local SizeComp = Comp:getContentSize()
				Comp._ListHighLightSpr:drawCircle(cc.p(ICON_SIZE/2,ICON_SIZE/2), ICON_SIZE/2+1, math.pi*2, 32, false, cc.c4f(1.0, 0.0, 0.0, 1.0))
				KE_SetParent(Comp._ListHighLightSpr, Comp)
			end
		else
			if Comp._ListHighLightSpr then
				KE_SafeDelete(Comp._ListHighLightSpr)
				Comp._ListHighLightSpr = nil 
			end
		end
	end
	compList:SetCellRefresher(function(CellComp, CellObj)
		
	end)
	compList:SetCellCreator(function(CellObj)
		local respath = string.format("res/uiface/wnds/country/beauty%d.png", CellObj:GetCellId())
		local btn = ccui.Button:create(respath, respath)
		return btn
	end)
	compList:AddListener("lis_click_cell", "ec_click_cell", function(CellObj)
		print("点击美人", CellObj:GetCellId())
	end)
	
	--
	local beauty_list = {
		{ Id=1, Name="杨贵妃", },
		{ Id=2, Name="妲己", },
		{ Id=3, Name="西施", },
		{ Id=4, Name="潘金莲", },
	}
	for _, info in ipairs(beauty_list) do
		compList:Insert(info, info.Id)
	end
	compList:ForceReLayout()
	
	return self.mCompBeautyList
end

function clsBeautyPanel:CreateHeart(parent)
	local center = cc.Node:create()
	KE_SetParent(center, parent)
	
	local wid, hei = 20,20
	local heart_list = {}
	local pos_list = {
		[1] =  { 0, 0 },
		
		[2] =  { wid, hei },
		[3] =  { -wid, hei },
		[4] =  { wid*2, hei },
		[5] =  { -wid*2, hei },
		[6] =  { wid*3, 0 },
		[7] =  { -wid*3, 0 },
		[8] =  { wid*2, -hei },
		[9] =  { -wid*2, -hei },
		[10] = { wid, -hei*2 },
		[11] = { -wid, -hei*2 },
		
		[12] = { 0, -hei*3 },
	}
	for i=1, 12 do
		heart_list[i] = cc.Sprite:create("res/uiface/wnds/country/xin4.png")
		heart_list[i]:setPosition(pos_list[i][1], pos_list[i][2])
		KE_SetParent(heart_list[i], center)
	end
	
	return center
end
