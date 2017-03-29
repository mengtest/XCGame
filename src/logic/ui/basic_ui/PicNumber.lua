-------------------
-- 图片数字
-------------------
module("ui", package.seeall)

clsPicNumber = class("clsPicNumber", clsWindow)

function clsPicNumber:ctor(parent)
	clsWindow.ctor(self, parent)
--	self.iValue = nil
	self.iWidth = 0
	self.iHeight = 0
end

function clsPicNumber:dtor()
	
end

function clsPicNumber:SetValue(iValue)
	assert(iValue>=0, "参数不可为负数: "..iValue)
	if self.iValue == iValue then return end
	self.iValue = iValue
	
	self.mSprList = self.mSprList or {}
	for _, spr in pairs(self.mSprList) do
		KE_SafeDelete(spr)
	end
	self.mSprList = {}
	
	local tblValue = math.Num2Tbl(iValue)
	local curX = 0
	for i = #tblValue, 1, -1 do
		local spr = cc.Sprite:create(string.format("res/texts/num_big_%d.png",tblValue[i]))
		spr:setAnchorPoint(cc.p(0,0.5))
		spr:setPositionX(curX)
		KE_SetParent(spr, self)
		table.insert(self.mSprList, spr)
		curX = curX + spr:getContentSize().width
	end
	
	self.iWidth = curX
	self.iHeight = self.mSprList[1]:getContentSize().height
end

function clsPicNumber:GetValue()
	return self.iValue
end

function clsPicNumber:GetSize()
	return self.iWidth, self.iHeight
end
