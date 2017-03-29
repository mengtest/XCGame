---------------
-- 塔
---------------
local ROW = 20
local COL = 40

clsTowerManager = class("clsTowerManager", clsCoreObject)
clsTowerManager.__is_singleton = true

function clsTowerManager:ctor()
	clsCoreObject.ctor(self)
	self._GridList = {}
end

function clsTowerManager:dtor()
	for r, objlist in pairs(self._GridList) do
		for c, Obj in pairs(objlist) do
			KE_SafeDelete(Obj)
		end
	end
	self._GridList = {}
end

function clsTowerManager:FillGrid(r,c,Obj)
	assert(r>=1 and r<=ROW) 
	assert(c>=1 and c<=COL) 
	assert(Obj, "无效的建筑")
	self._GridList[r] = self._GridList[r] or {}
	assert(not self._GridList[r][c], string.format("已经有建筑: [%d,%d]",r,c))
	self._GridList[r][c] = Obj
	Obj:SetGridPos(r,c)
end

function clsTowerManager:ClearGrid(r,c)
	if not self._GridList[r] or not self._GridList[r][c] then return end
	KE_SafeDelete(self._GridList[r][c])
	self._GridList[r][c] = nil 
end

function clsTowerManager:RemoveBuilding(Obj)
	local r,c = Obj:GetGridPos()
	self:ClearGrid(r,c)
end
