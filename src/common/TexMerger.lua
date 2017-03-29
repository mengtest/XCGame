Grid = class("Grid")

function Grid:ctor(w,h,offX,offY)
	self.width = w			--格子宽
	self.height = h			--格子高
	self.offsetX = offX		--格子x偏移
	self.offsetY = offY		--格子y偏移
end 

function Grid:GetWidth() return self.width end 
function Grid:GetHeight() return self.height end 
function Grid:GetOffsetX() return self.offsetX end 
function Grid:GetOffsetY() return self.offsetY end 

--------------------------------------------------------------

TexMerger = class("TexMerger")

function TexMerger:ctor(Wid, Hei)
	self._wid = Wid or 600		--合图宽
	self._hei = Hei or 600 		--合图高
	self._all_grids = {}		--根据图片路径索引Grid
	self._row_list = {}			--根据格子行列排布索引Grid
	self._curY = self._hei - 5	--从0到self._curY为合图中尚未弄脏的区域
	self._space = 5 			--格子之间的间距
end 

function TexMerger:AddImage(sPath)
	if self._all_grids[sPath] then return self._all_grids[sPath] end 
	
	local w,h = math.random(10,190),math.random(10,190)
	local gridObj = self:FindSlot(w,h)
	
	if gridObj then
		self._all_grids[sPath] = gridObj
		return self._all_grids[sPath]
	end 
end 

function TexMerger:FindSlot(w,h)
	-- 尺寸过大的图片不合批
	if h > 250 or w > 250 then return nil end 
	
	-- 找到hei最逼近且能放下去的行
	local bHasFinded = false 
	local nearestInfo = {
		disH = 9999,
		rowinfo = nil,
	}
	for r, rowinfo in ipairs(self._row_list) do 
		if rowinfo.h-h >= 0 and rowinfo.curX + w + self._space <= self._wid then
			if rowinfo.h-h < nearestInfo.disH then
				nearestInfo.disH = rowinfo.h-h
				nearestInfo.rowinfo = rowinfo
				bHasFinded = true
			end 
		end
	end 
	--如果留白太多，换行
	if bHasFinded and nearestInfo.disH > nearestInfo.rowinfo.h/2 and self._curY - h - self._space >= 0 then
		bHasFinded = false
	end
	
	local gridObj 
	
	if bHasFinded then
	-- 找到了可插入的行则插入该行
		local rowinfo = nearestInfo.rowinfo
		gridObj = Grid.new(w,h,rowinfo.curX,rowinfo.y)
		table.insert(rowinfo.grid_list, gridObj)
		rowinfo.curX = rowinfo.curX + w + self._space
	else 
	-- 没找到则尝试新起一行插入
		local tmpY = self._curY - h - self._space
		if tmpY >= 0 then
			self._curY = tmpY
			local rowinfo = {
				curX = self._space,
				y = self._curY + self._space,
				h = h,
				grid_list = {},
			}
			table.insert(self._row_list, rowinfo)
			
			if rowinfo.curX + w + self._space <= self._wid then
				gridObj = Grid.new(w,h,rowinfo.curX,rowinfo.y)
				table.insert(rowinfo.grid_list, gridObj)
				rowinfo.curX = rowinfo.curX + w + self._space
			end 
		end 
	end 
	
	return gridObj
end 

function TexMerger:Draw(Parent)
	local drawNode = cc.DrawNode:create()
	Parent:addChild(drawNode)
	
	for r, rowinfo in ipairs(self._row_list) do 
		for c, gridObj in ipairs(rowinfo.grid_list) do 
			drawNode:drawRect(
				cc.p(gridObj.offsetX+gridObj.width, gridObj.offsetY+gridObj.height), 
				cc.p(gridObj.offsetX, gridObj.offsetY), 
				cc.c4f(1,1,0,1)
			)
		end 
	end 
end 

function TexMerger:DumpDebugInfo()
	for r, rowinfo in ipairs(self._row_list) do 
		print("---- 行：", r, rowinfo.curX, rowinfo.y, rowinfo.h)
		for c, gridObj in ipairs(rowinfo.grid_list) do 
			print(c, gridObj.width, gridObj.height, gridObj.offsetX, gridObj.offsetY)
		end 
	end 
end 


function TestTexMerger(Parent)
	print("++++++++++++++++++++++++++++++++++++++")
	InstTexMerge = TexMerger.new()
	for i=1, 200 do 
		print(i, InstTexMerge:AddImage("img"..i))
	end 
	InstTexMerge:DumpDebugInfo()
	InstTexMerge:Draw(Parent)
end 
