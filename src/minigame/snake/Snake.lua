------------------
-- 贪吃蛇
------------------
module("ui", package.seeall)

local SNAKE_STYLE = {
	[1] = {
		HeadImg = "res/redpoint.png",
		BodyImgs = {
			"res/redpoint.png",
			"res/redpoint.png",
		},
	},
}

clsSnake = class("clsSnake")

function clsSnake:ctor(parent, SnakeId, StyleId)
	local cfg = SNAKE_STYLE[StyleId]
	
	self._Parent = parent
	self._SnakeId = SnakeId
	self._StyleId = StyleId
	self._CurDirection = 0
	self._CurSpeed = 2
	self.tBodyList = {}
	
	self.tBodyList[1] = cc.Sprite:create(cfg.HeadImg)
	KE_SetParent(self.tBodyList[1], self._Parent)
	self.tBodyList[1]:setPosition(math.random(200,100),math.random(200,600))
	
	self:AddLength(10)
end

function clsSnake:dtor()
	
end

function clsSnake:setPosition(x,y)
	local preX,preY = self.tBodyList[1]:getPosition()
	local dx,dy = x-preX, y-preY
	for i=2, #self.tBodyList do
		local curX,curY = self.tBodyList[i]:getPosition()
		self.tBodyList[i]:setPosition(curX+dx,curY+dy)
	end
end

function clsSnake:AddLength(Len)
	local cfg = SNAKE_STYLE[self._StyleId]
	for i=1, Len do
		local CurLen = #self.tBodyList + 1
		self.tBodyList[CurLen] = cc.Sprite:create(cfg.BodyImgs[1])
		KE_SetParent(self.tBodyList[CurLen],self._Parent)
		local x,y = self.tBodyList[CurLen-1]:getPosition()
		self.tBodyList[CurLen]:setPosition(x+5,y+5)
	end
end

function clsSnake:AddThickness(Value)
	local CurScale = self:getScale() + Value
	self:setScale(math.max(1,CurScale))
end

function clsSnake:SetDirection(direction)
	self._CurDirection = direction
	
end 

function clsSnake:SetSpeed(speed)
	self._CurSpeed = speed
end	

function clsSnake:Move()
	local speed = self._CurSpeed
	local direction = self._CurDirection
	local x,y = self.tBodyList[1]:getPosition()
	self:setPosition(x+speed*math.cos(direction),y+speed*math.sin(direction))
end
