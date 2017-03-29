------------------
-- 文件选择面板
------------------
module("ui", package.seeall)

clsLuaPanel = class("clsLuaPanel", ui.clsWindow)

function clsLuaPanel:ctor(parent)
	ui.clsWindow.ctor(self, parent)
	
	self.m_AllLuaFiles = {}
	
	self:InitAll()
end

function clsLuaPanel:dtor()
	
end

-- folderName = folderName or "/src/data/uiconfigs"
function clsLuaPanel:Reset(folderName, OnSelectCell)
	assert(folderName,"folderName can not be nil")
	assert(is_function(OnSelectCell))
	self._FuncOnSelectCell = OnSelectCell
	if self._CurFolder == folderName then return end
	self._CurFolder = folderName
	
	self.m_AllLuaFiles = io.SearchFolderByMode(folderName, "%.lua$")
	
	local ListWnd = self.mListWnd
	ListWnd:RemoveAll()
	for _, filename in ipairs(self.m_AllLuaFiles) do
		ListWnd:Insert(filename, filename)
	end
	self.mListWnd:ForceReLayout()
end

function clsLuaPanel:InitAll()
	self.mListWnd = ui.clsCompList.new(self, ccui.ScrollViewDir.vertical, 520, 640, 520, 40)
	self.mListWnd:setPosition(-260,-350)
	self.mListWnd:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create("res/uiface/buttons/btn_blue.png", "res/uiface/buttons/btn_green.png")
		btn:setScale9Enabled(true) 
		btn:setContentSize(520,40) 
		btn:setTitleText(CellObj:GetCellData())
		return btn
	end)
			
	self.mListWnd:AddListener(self, "ec_click_cell", function(CellObj)
		local filepath = CellObj:GetCellData()
		self._FuncOnSelectCell(filepath)
		self:Show(false)
	end)
	
	--
	self.m_LuaFilter = ccui.EditBox:create(cc.size(500,40), "res/uiface/panels/edit_bg_4.png") 
	KE_SetParent(self.m_LuaFilter, self)
	self.m_LuaFilter:setPosition(0,320)
	local function editboxEventHandler(eventType)
		if eventType == "began" then
			-- triggered when an edit box gains focus after keyboard is shown
		elseif eventType == "ended" then
			-- triggered when an edit box loses focus after keyboard is hidden.
		elseif eventType == "changed" then
			-- triggered when the edit box text was changed.
		elseif eventType == "return" then
			-- triggered when the return button was pressed or the outside area of keyboard was touched.
			self.mListWnd:RemoveAll()
			local string_find = string.find
			local string_lower = string.lower
			local ListWnd = self.mListWnd
			local filterStr = string_lower(self.m_LuaFilter:getText())
			for _, filename in ipairs(self.m_AllLuaFiles) do
				if string_find(string_lower(filename), filterStr) then
					ListWnd:Insert(filename, filename)
				end
			end
			self.mListWnd:ForceReLayout()
		end
	end
	self.m_LuaFilter:registerScriptEditBoxHandler(editboxEventHandler)
end
