------------------
-- list控件
------------------
module("ui", package.seeall)


local clsListCell = class("clsListCell")

function clsListCell:ctor(CellId, CellData)
	self._CellId = CellId
	self._CellData = CellData
	self._bSelected = false
	self._CellComp = nil
	
	AddMemoryMonitor(self)
end

function clsListCell:dtor()
	if self._CellComp then
		KE_SafeDelete(self._CellComp)
		self._CellComp = nil 
	end
end

function clsListCell:GetCellId() return self._CellId end
function clsListCell:GetCellData() return self._CellData end
function clsListCell:GetCellComp() return self._CellComp end
function clsListCell:IsSelected() return self._bSelected end

------------------------------------------------------------------

clsCompList = class("clsCompList", clsListView, clsCoreObject)

clsCompList:RegisterEventType("ec_click_cell")

function clsCompList:ctor(parent, Direction, ListWid, ListHei, CellWid, CellHei, bkgImgPath)
	assert(Direction == ccui.ScrollViewDir.vertical or Direction == ccui.ScrollViewDir.horizontal, "不支持滚动方向: "..Direction)
	assert(ListWid and ListHei and CellWid and CellHei, "这些参数不可为空")
	clsListView.ctor(self, parent)
	clsCoreObject.ctor(self)
	
	AddMemoryMonitor(self)
	
	--
	self.mCellList = {}
	self.tAllCellById = new_weak_table("v")
	
	self._HighLightImgPath = "res/icons/frame/frame_choosed.png"
	
	self._fCellCreator = nil
	self._fCellRefresher = nil
	
	self._CurFrom = nil
	self._CurTo = nil
	self.mCellParent = nil
	self.mInerContainer = nil
	
	self.iDirection = Direction
	self.iListWid = ListWid
	self.iListHei = ListHei
	self.iCellWidth = CellWid
	self.iCellHeight = CellHei
	
	if Direction == ccui.ScrollViewDir.vertical then 
		self.iMaxShowCnt = math.ceil(ListHei/CellHei)+1
	else
		self.iMaxShowCnt = math.ceil(ListWid/CellWid)+1
	end
	self.iMaxShowCnt = math.max(1, self.iMaxShowCnt)
	
	--
	self:_OnInit(Direction, ListWid, ListHei, bkgImgPath)
end

function clsCompList:dtor()
	self:_RemoveAll()
end

function clsCompList:_OnInit(Direction, ListWid, ListHei, bkgImgPath)
	self:setDirection(Direction)
	self:setBounceEnabled(true)
	self:setBackGroundImageScale9Enabled(true)
	if bkgImgPath then self:setBackGroundImage(bkgImgPath) end
	self:setContentSize(cc.size(ListWid, ListHei))
	
	local default_item = ccui.Layout:create()
	default_item:setTouchEnabled(true)
	default_item:setContentSize(ListWid, ListHei)
	self:setItemModel(default_item)
	
	self:pushBackDefaultItem()
	self.mCellParent = self:getItem(0)
	self.mInerContainer = self:getInnerContainer()  -- self.mCellParent:getParent()
	
	-- 事件
	self:addScrollViewEventListener(function(sender, evenType)
		if evenType == 9 then  -- InerContainer位置发生了变化
			self:_OnContainerPosChg(self.mInerContainer:getPosition())
		end
	end)
end

function clsCompList:_UpdateCellParentSize()
	local ListWid, ListHei = self.iListWid, self.iListHei
	if self.iDirection == ccui.ScrollViewDir.vertical then 
		self.mCellParent:setContentSize( ListWid, math.max(self.iCellHeight*#self.mCellList, ListHei) )
	else
		self.mCellParent:setContentSize( math.max(self.iCellWidth*#self.mCellList, ListWid), ListHei )
	end
	self:forceDoLayout()
end

function clsCompList:_CalCellPos(iIdx)
	if self.iDirection == ccui.ScrollViewDir.vertical then
		local tSize = self.mCellParent:getContentSize()
		return tSize.width/2, tSize.height+(-iIdx+0.5)*self.iCellHeight
	else
		return iIdx*self.iCellWidth-self.iCellWidth/2, self.iListHei/2
	end
end

function clsCompList:_OnContainerPosChg(x,y)
	if self.iDirection == ccui.ScrollViewDir.vertical then 
		local bottom_row = #self.mCellList + math.ceil(y/self.iCellHeight) 
		local top_row = bottom_row - self.iMaxShowCnt
		self:_OnSeeableCellsChg(top_row, bottom_row)
	else
		local left_col = -math.floor(x/self.iCellWidth) 
		local right_col = left_col + self.iMaxShowCnt
		self:_OnSeeableCellsChg(left_col, right_col)
	end
end

function clsCompList:_OnSeeableCellsChg(fromIdx, toIdx)
	if self._CurFrom == fromIdx and self._CurTo == toIdx then return end
	self._CurFrom = fromIdx
	self._CurTo = toIdx
	for idx = fromIdx, toIdx do
		self:_OnCellSeeable(idx)
	end
	
	for i=fromIdx-5, 1, -1 do
		if not self.mCellList[i] then break end
		KE_SafeDelete(self.mCellList[i]._CellComp)
		self.mCellList[i]._CellComp = nil
	end
	for i=toIdx+5, #self.mCellList do
		if not self.mCellList[i] then break end
		KE_SafeDelete(self.mCellList[i]._CellComp)
		self.mCellList[i]._CellComp = nil
	end
end

function clsCompList:_OnCellSeeable(idx)
	local CellObj = self.mCellList[idx]
	if not CellObj then return end
	if CellObj._CellComp then return end
	
	--创建子元素
	CellObj._CellComp = self._fCellCreator(CellObj)
	KE_SetParent(CellObj._CellComp, self.mCellParent)
	CellObj._CellComp:setPosition(self:_CalCellPos(idx))
	
	if CellObj._CellComp.addTouchEventListener then
		CellObj._CellComp:addTouchEventListener(function(sender, eventType)
			if eventType ~= ccui.TouchEventType.ended then return end 
			self:OnClickCellComp(CellObj)
		end)
	end
	
	--刷新子元素组件
	self:_RefreshCellComp(CellObj)
end

-------------------
-- 以下为对外接口
-------------------
function clsCompList:OnClickCellComp(CellObj)
	self:SetSelectCell(CellObj)
end

function clsCompList:SetCellCreator(cellCreator)
	assert(is_function(cellCreator), "Cell的创建接口必须为函数")
	self._fCellCreator = cellCreator
end

function clsCompList:SetCellRefresher(cellRefresher)
	assert(is_function(cellRefresher), "Cell的刷新接口必须为函数")
	self._fCellRefresher = cellRefresher
end

-- Insert或Remove后须手动调用一下ForceReLayout才会刷新视图。
function clsCompList:Insert(CellData, CellId, idx)
	if CellId and self.tAllCellById[CellId] then
		assert(false, "已经添加过该ID的元素："..CellId)
		return 
	end
	
	idx = idx or #self.mCellList+1
	assert(idx >= 1 and idx <= #self.mCellList+1)
	local CellObj = clsListCell.new(CellId, CellData) 
	table.insert(self.mCellList, idx, CellObj)
	if CellId then self.tAllCellById[CellId] = CellObj end
	
	self._iCellPosDirty = idx
	self:_UpdateCellParentSize()
	
	return CellObj
end

-- Insert或Remove后须手动调用一下ForceReLayout才会刷新视图。
function clsCompList:Remove(idx)
	idx = idx or #self.mCellList
	local CellObj = self.mCellList[idx]
	if not CellObj then return end
	
	if self._CurSelectCell == CellObj then self._CurSelectCell = nil end
	if CellObj._CellId then self.tAllCellById[CellObj._CellId] = nil end
	KE_SafeDelete(CellObj)
	table.remove(self.mCellList, idx)
	
	self._iCellPosDirty = idx
	self:_UpdateCellParentSize()
end

function clsCompList:_RemoveAll()
	self._CurSelectCell = nil
	for _, CellObj in pairs(self.mCellList) do
		KE_SafeDelete(CellObj)
	end
	self.mCellList = {}
	self.tAllCellById = new_weak_table("v")
	self._CurFrom = nil
	self._CurTo = nil
end

function clsCompList:RemoveAll()
	self:_RemoveAll()
	self:_UpdateCellParentSize()
end

-- Insert或Remove后须手动调用一下ForceReLayout刷新视图。
function clsCompList:ForceReLayout()
	local maxPos = #self.mCellList 
	for idx = 1, maxPos do
		local CellObj = self.mCellList[idx]
		if CellObj._CellComp then 
			CellObj._CellComp:setPosition(self:_CalCellPos(idx))
		end
	end
	
	self._CurFrom = nil
	self._CurTo = nil
	self:_OnContainerPosChg(self.mInerContainer:getPosition())
end

-- 更新数据
function clsCompList:UpdateCellDataById(id, CellData)
	if not self.tAllCellById[id] then return end
	self.tAllCellById[id]._CellData = CellData
	self:RefreshCellCompById(id)
end

-- 更新数据
function clsCompList:UpdateCellDataByIdx(idx, CellData)
	if not self.mCellList[idx] then return end
	self.mCellList[idx]._CellData = CellData
	self:RefreshCellCompByIdx(idx)
end

function clsCompList:RefreshCellCompByIdx(idx)
	if not self.mCellList[idx] then return end
	self:_RefreshCellComp(self.mCellList[idx])
end

function clsCompList:RefreshCellCompById(id)
	if not self.tAllCellById[id] then return end
	self:_RefreshCellComp(self.tAllCellById[id])
end

function clsCompList:_RefreshCellComp(CellObj)
	local CellComp = CellObj and CellObj._CellComp
	if not CellComp then return end
	if CellObj._bSelected then
		self:HighLightSelectComp(CellComp, true)
	end
	if self._fCellRefresher then
		self._fCellRefresher(CellComp, CellObj)
	end
end

function clsCompList:GetCellParent() return self.mCellParent end
function clsCompList:GetInerContainer() return self.mInerContainer end
function clsCompList:GetCellList() return self.mCellList end
function clsCompList:GetCellCount() return #self.mCellList end
function clsCompList:GetCellByIdx(idx) return self.mCellList[idx] end
function clsCompList:GetCellById(id) return self.tAllCellById[id] end
function clsCompList:GetCellCompById(id) return self.tAllCellById[id] and self.tAllCellById[id]._CellComp end
function clsCompList:GetCellCompByIdx(idx) return self.mCellList[idx] and self.mCellList[idx]._CellComp end

function clsCompList:GetCellIdxById(id) 
	if id == nil then return nil end
	for idx, CellObj in ipairs(self.mCellList) do
		if CellObj._CellId == id then return idx end
	end
	return nil 
end

function clsCompList:GetIdxOfCellComp(CellComp)
	if not CellComp then return nil end
	for idx, CellObj in ipairs(self.mCellList) do
		if CellObj._CellComp == CellComp then return idx end
	end
	return nil 
end

function clsCompList:GetCellIdxByCellObj(CellObj)
	if not CellObj then return nil end
	for idx, ObjCell in ipairs(self.mCellList) do
		if CellObj == ObjCell then return idx end
	end
	return nil 
end

function clsCompList:ForeachCellObjs(Func)
	for idx, CellObj in ipairs(self.mCellList) do
		Func(CellObj)
	end
end

--------------------------------------------------------

function clsCompList:SetHighLightImgPath(imgpath)
	self._HighLightImgPath = imgpath
end

function clsCompList:HighLightSelectComp(Comp, bHighLight)
	if not Comp then return end
	
	if bHighLight and self._HighLightImgPath then
		if not Comp._ListHighLightSpr then 
			Comp._ListHighLightSpr = cc.Scale9Sprite:create(self._HighLightImgPath)
			local SizeComp = Comp:getContentSize()
			Comp._ListHighLightSpr:setContentSize(SizeComp)
			Comp._ListHighLightSpr:setPosition(SizeComp.width/2, SizeComp.height/2)
			KE_SetParent(Comp._ListHighLightSpr, Comp)
		end
	else
		if Comp._ListHighLightSpr then
			KE_SafeDelete(Comp._ListHighLightSpr)
			Comp._ListHighLightSpr = nil 
		end
	end
end

function clsCompList:SetSelectCellSilent(CellObj)
	if self._CurSelectCell then
		self._CurSelectCell._bSelected = false
		self:HighLightSelectComp(self._CurSelectCell._CellComp, false)
	end
	
	self._CurSelectCell = CellObj
	
	if CellObj then 
		CellObj._bSelected = true 
		self:HighLightSelectComp(CellObj._CellComp, true)
	end
end

function clsCompList:SetSelectCell(CellObj)
	self:SetSelectCellSilent(CellObj)
	self:FireEvent("ec_click_cell", CellObj)
end

function clsCompList:SetSelectedIdx(Idx)
	self:SetSelectCell(self.mCellList[Idx])
end

function clsCompList:SetSelectedId(CellId)
	self:SetSelectCell(self.tAllCellById[CellId])
end

function clsCompList:GetSelectedCell()
	return self._CurSelectCell
end

function clsCompList:GetSelectedIdx()
	return self:GetCellIdxByCellObj(self._CurSelectCell)
end

function clsCompList:GetSelectedId()
	return self._CurSelectCell and self._CurSelectCell._CellId
end

function clsCompList:GetSelectedComp()
	return self._CurSelectCell and self._CurSelectCell._CellComp
end
