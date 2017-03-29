----------------------
--[[

clsGameObject: 游戏内物体对象基类（人物，法术体等）

属性与方法：
	1. 位置 
	2. 移动 
	3. 旋转
	4. 定义实体资源加载方式的抽象接口

组成结构：
GameObject
	Body
	Shadow
	Others(name_label, HP_bar, ...) 

]]--
----------------------

local tolua_isnull = tolua.isnull

clsGameObject = class("clsGameObject", clsNode, clsCoreObject)

clsGameObject:RegisterEventType(const.CORE_EVENT.EC_SHOW)

function clsGameObject:ctor(parent)
	clsNode.ctor(self,parent)
	clsCoreObject.ctor(self)
	
	self._iCurDir = 0			--朝向 [0~2PI]
	self._iPosX = 0				--位置X
	self._iPosY = 0				--位置Y
	self._iPosH = 0				--位置H
	self._iCurMoveSpeed = 0		--水平方向速度
	self._iCurSkySpeed = 0		--竖直方向速度
	self._mBody = nil 			--模型实体
	
	self._bIsShow = true
end

function clsGameObject:dtor()
	self:FireEvent(const.CORE_EVENT.EC_SHOW, false)
end

function clsGameObject:Show(bShow)
	assert(bShow ~= nil, "参数不对")
	if self._bIsShow == bShow then return end
	self._bIsShow = bShow
	self:setVisible(bShow)
	self:FireEvent(const.CORE_EVENT.EC_SHOW, bShow)
end

function clsGameObject:IsShow()
	return self._bIsShow
end

--------------------
-- 位置相关
--------------------
clsGameObject.__setPosition = cc.Node.setPosition
clsGameObject.setPosition = function(self,x,y)
	if self._iPosX == x and self._iPosY == y then return end
	self._iPosX, self._iPosY = x, y
	self:__setPosition(x,y)
end

clsGameObject.__getPosition = cc.Node.getPosition
clsGameObject.getPosition = function(self)
	return self._iPosX, self._iPosY
end

clsGameObject.__setPositionX = cc.Node.setPositionX
clsGameObject.setPositionX = function(self, x)
	if self._iPosX == x then return end
	self._iPosX = x
	self:__setPositionX(x)
end

clsGameObject.__getPositionX = cc.Node.getPositionX
clsGameObject.getPositionX = function(self)
	return self._iPosX
end

clsGameObject.__setPositionY = cc.Node.setPositionY
clsGameObject.setPositionY = function(self, y)
	if self._iPosY == y then return end
	self._iPosY = y
	self:__setPositionY(y)
end

clsGameObject.__getPositionY = cc.Node.getPositionY
clsGameObject.getPositionY = function(self)
	return self._iPosY
end

clsGameObject.__runAction = cc.Node.runAction
clsGameObject.runAction = function(self, act)
	local act__ = self:__runAction(act)
		
	KE_SetInterval(1, function()
		if tolua_isnull(self) then return true end
			
		self._iPosX, self._iPosY = self:__getPosition()
			
		if tolua_isnull(act__) then 
			KE_SetTimeout(1, function()
				if not tolua_isnull(self) then
					self._iPosX, self._iPosY = self:__getPosition()
				end
			end)
			return true 
		end
	end)
		
	return act__ 
end

-- 位置：高度
clsGameObject.SetPositionH = function(self, h)
--	if self._iPosH == h then return end
--	self._iPosH = h
	if self._mBody then self._mBody:setPositionY(h) end
end

-- 位置：高度
clsGameObject.GetPositionH = function(self)
--	return self._iPosH
	return self._mBody and self._mBody:getPositionY() or 0
end

-- 虚拟三维位置
function clsGameObject:SetPosition3D(x,y,h)
	self:setPosition(x,y)
	self:SetPositionH(h)
end

-- 虚拟三维位置
function clsGameObject:GetPosition3D()
	return self._iPosX, self._iPosY, self:GetPositionH()
end

-- 是否处在空中
function clsGameObject:IsInSky() 
	return self:GetPositionH() > 0 
end

--------------------
-- 移动相关
--------------------
-- 设置水平方向速度
function clsGameObject:SetCurMoveSpeed(iSpeed)
	assert(is_number(iSpeed))
	self._iCurMoveSpeed = iSpeed
end

-- 获取水平方向速度
function clsGameObject:GetCurMoveSpeed()
	return self._iCurMoveSpeed
end

-- 设置竖直方向速度
function clsGameObject:SetCurSkySpeed(iSpeed)
	assert(is_number(iSpeed))
	self._iCurSkySpeed = iSpeed
end

-- 获取竖直方向速度
function clsGameObject:GetCurSkySpeed()
	return self._iCurSkySpeed
end

-- 增加竖直方向速度
function clsGameObject:AddCurSkySpeed(iDelta)
	assert(is_number(iDelta))
	self._iCurSkySpeed = self._iCurSkySpeed + iDelta
	return self._iCurSkySpeed
end

--------------------
-- 旋转相关
--------------------
-- 设置朝向
local DOUBLE_PI = math.pi*2
function clsGameObject:SetDirection(iDir)
	if not iDir then return end
	if iDir == self._iCurDir then return end
	assert(iDir>=0 and iDir<=DOUBLE_PI)
	self._iCurDir = iDir
	
	self:OnDirectionChanged(iDir)
end

function clsGameObject:OnDirectionChanged(iDir)

end

-- 获取朝向
function clsGameObject:GetDirection()
	return self._iCurDir
end

-- 面向坐标点(x,y)
function clsGameObject:FaceTo(x, y)
	local sx, sy = self:getPosition()
	local dX, dY = x-sx, y-sy
	if dX == 0 and dY == 0 then return end
	self:SetDirection( math.Vector2Radian(dX, dY) )
end

--------------------
-- 资源相关
--------------------
-- 加载躯体
function clsGameObject:_LoadBody()
	assert(false, "子类请自行重载")
end

-- 卸载躯体
function clsGameObject:_UnloadBody()
	assert(false, "子类请自行重载")
end

-- 获取躯体
function clsGameObject:GetBody()
	return self._mBody
end
