------------------
-- 打地鼠
------------------
module("ui", package.seeall)

clsWhacAMole = class("clsWhacAMole", clsCommonFrame)

function clsWhacAMole:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_whac_a_mole/whacamole.lua", "打地鼠")
	
	self._bGaming = false
	self._CurScore = 0 
	self._CurType = nil
	self._CurHole = nil
	
	self:GetCompByName("LabelScore"):setString("分数："..self._CurScore)
	
	self:InitObjects()
	self:BeginGame()
end

function clsWhacAMole:dtor()
	
end

function clsWhacAMole:InitObjects()
	self._HoleList = {}
	for i=1,3 do
		for j=1,3 do
			local BtnHole = ccui.Button:create("res/uiface/buttons/btn_blue.png", "res/uiface/buttons/btn_green.png")
			table.insert(self._HoleList, BtnHole)
			BtnHole._Id = #self._HoleList
			BtnHole:setScale9Enabled(true) 
			BtnHole:setContentSize(120,120) 
			BtnHole:setPosition(200*i, 130*j)
			BtnHole:setTitleFontSize(40)
			KE_SetParent(BtnHole, self)
			utils.RegButtonEvent(BtnHole, function()
				if self._CurHole == BtnHole._Id then
					if self._CurType == 1 then
						self:AddScore(1)
						self:ToStateCd()
					elseif self._CurType == 2 then
						self:SubScore(1)
						self:ToStateCd()
					end
				end
			end)
		end
	end
end

function clsWhacAMole:AddScore(iScore)
	self._CurScore = self._CurScore + iScore
	self:GetCompByName("LabelScore"):setString("分数："..self._CurScore)
end

function clsWhacAMole:SubScore(iScore)
	self._CurScore = self._CurScore - iScore
	self:GetCompByName("LabelScore"):setString("分数："..self._CurScore)
end

function clsWhacAMole:BeginGame()
	self._bGaming = true
	self:ToStateCd()
end

function clsWhacAMole:ToStateCd()
	-- on leave pre state
	self:DestroyTimer("tm_hit")
	if self._CurHole then self._HoleList[self._CurHole]:setTitleText("") end
	self._CurType = nil
	self._CurHole = nil
	
	-- on enter cur state
	local cdLen = math.random(1,3)
	self:CreateAbsTimerDelay("tm_cd", cdLen, function()
		self:DestroyTimer("tm_cd")
		self:ToStateHit()
	end)
end

function clsWhacAMole:ToStateHit()
	-- on leave pre state
	self:DestroyTimer("tm_cd")
	self._CurType = math.random(1,2)
	self._CurHole = math.random(1,9)
	self._HoleList[self._CurHole]:setTitleText(self._CurType)
	
	-- on enter cur state
	local cdHid = math.random(100,300)/100
	self:CreateAbsTimerDelay("tm_hit", cdHid, function()
		self:DestroyTimer("tm_hit")
		self:ToStateCd()
	end)
end

function clsWhacAMole:StopGame(reason)
	if self._CurHole then self._HoleList[self._CurHole]:setTitleText("") end
	self._CurHole = nil
	self._CurType = nil
	self:DestroyTimer("tm_cd")
	self:DestroyTimer("tm_hit")
	self._bGaming = false
end
