------------------
-- 贪吃蛇
------------------
module("ui", package.seeall)

clsNibblesView = class("clsNibblesView", clsWindow)

function clsNibblesView:ctor(parent)
	clsWindow.ctor(self, parent)
	self.tAllSnakes = {}
	self:AddSnake(1,1)
	
	ClsUpdator.GetInstance():RegisterUpdator(self.FrameUpdate, self, ClsUpdator.ORDER_PHYSICS)
end

function clsNibblesView:dtor()
	ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
end

function clsNibblesView:FrameUpdate(dt)
	for _, obj in pairs(self.tAllSnakes) do
		obj:Move()
	end
end

function clsNibblesView:AddSnake(SnakeId, StyleId)
	self.tAllSnakes[SnakeId] = clsSnake.new(self, SnakeId, StyleId)
--	
end
