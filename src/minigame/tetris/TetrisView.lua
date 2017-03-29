------------------
-- 俄罗斯方块
------------------
module("ui", package.seeall)

clsTetrisView = class("clsTetrisView", clsCommonFrame)

function clsTetrisView:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_tetris/tetrisview.lua", "俄罗斯方块")
	
	self._bGaming = false
	self._CurScore = 0 
	
	self:InitObjects()
	self:BeginGame()
end

function clsTetrisView:dtor()
	
end

function clsTetrisView:InitObjects()
	
end

function clsTetrisView:SetCurScore(iScore)
	self._CurScore = iScore
	self:GetCompByName("LabelScore"):setString("分数："..self._CurScore)
end

function clsTetrisView:BeginGame()
	self._bGaming = true
	self:SetCurScore(0)
end


function clsTetrisView:StopGame(reason)
	self._bGaming = false
end
