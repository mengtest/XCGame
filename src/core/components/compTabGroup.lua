-------------------
-- Tab标签
-------------------
module("ui", package.seeall)

clsCompTabGroup = class("clsCompTabGroup", clsCoreObject)

clsCompTabGroup:RegisterEventType("ec_select_changed")

function clsCompTabGroup:ctor(parent)
	clsCoreObject.ctor(self, parent)
	
	self.tTabButtons = {}
	self.tViews = {}
end

function clsCompTabGroup:dtor()
	self.tTabButtons = {}
	self.tViews = {}
end

function clsCompTabGroup:GetIdOfTabButton(TabBtn)
	for id, btn in pairs(self.tTabButtons) do
		if btn == TabBtn then
			return id
		end
	end
	return nil
end

function clsCompTabGroup:AddTabButton(id, TabBtn)
	assert(id and TabBtn)
	assert(not self.tTabButtons[id], "id已占用: "..id)
	assert(not self:GetIdOfTabButton(TabBtn), "已经添加该按钮")
	
	self.tTabButtons[id] = TabBtn
	
    utils.RegButtonEvent(TabBtn, function()
		if self._selected_id == id then
        	self:SetSelectedTabSlient(id)
        else
        	self:SetSelectedTab(id)
        end 
	end)
end

function clsCompTabGroup:BindView(id, subView)
	assert(self.tTabButtons[id] and subView)
	self.tViews[id] = subView
end

function clsCompTabGroup:SetSelectedTab(id)
	self:SetSelectedTabSlient(id)
	self:FireEvent("ec_select_changed", id, old_selected_id)
end

function clsCompTabGroup:SetSelectedTabSlient(id)
	local old_selected_id = self._selected_id
	self._selected_id = id
	self:OnSelectChange(id, old_selected_id)
	
	for view_id, subView in pairs(self.tViews) do
		subView:Show(view_id==id)
	end
end

-- 切换标签后的表现（默认为高亮显示选中的按钮，外部可重写该方法来定制表现）
function clsCompTabGroup:OnSelectChange(id, old_selected_id)
	for btn_id, btn in pairs(self.tTabButtons) do
		btn:setSelected(btn_id == id)
	end
end

function clsCompTabGroup:SetTabBtnEnable(id, bEnable)
	self.tTabButtons[id]:setEnabled(bEnable)
end

function clsCompTabGroup:GetSelectedId()
	return self._selected_id
end

function clsCompTabGroup:GetSelectedBtn()
	return self._selected_id and self.tTabButtons[self._selected_id]
end
