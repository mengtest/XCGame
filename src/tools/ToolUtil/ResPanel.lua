------------------
-- 资源选择面板
------------------
module("ui", package.seeall)

clsResPanel = class("clsResPanel", ui.clsWindow)

function clsResPanel:ctor(parent)
	ui.clsWindow.ctor(self, parent)
	
	self.m_AllImgFiles = {}
	
	self:InitAll()
	self:InitKeyBoardListener()
end

function clsResPanel:dtor()
	
end

function clsResPanel:Reset(OnSelectCell, bShowPreviewImg)
	assert(is_function(OnSelectCell))
	self._FuncOnSelectCell = OnSelectCell
	self._bShowPreviewImg = bShowPreviewImg
end

function clsResPanel:InitAll()
	self.mListWnd = ui.clsCompList.new(self, ccui.ScrollViewDir.vertical, 420, 600, 420, 40)
	self.mListWnd:setPosition(100,-400)
	
	self.mListWnd:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create("res/uiface/buttons/btn_blue.png", "res/uiface/buttons/btn_green.png")
		btn:setScale9Enabled(true) 
		btn:setContentSize(420,40) 
		btn:setTitleText(CellObj:GetCellData())
		return btn
	end)
			
	self.mListWnd:AddListener(self, "ec_click_cell", function(CellObj)
		local imgPath = CellObj:GetCellData()
		
		--刷新预览图
		KE_SafeDelete(self.mCurPreview)
		self.mCurPreview = nil
		if self._bShowPreviewImg and imgPath and imgPath ~= "" then
			self.mCurPreview = cc.Sprite:create(imgPath)
			KE_SetParent(self.mCurPreview, self)
			self.mCurPreview:setPosition(-200,0)
		end
		
		--回调
		self._FuncOnSelectCell(imgPath)
	end)
	
	--
	local string_find = string.find
	self.m_AllImgFiles = io.SearchFolderByFilter("/res", function(path)
		return string_find(path,"%.png$") or string_find(path,"%.jpg$")
	end)
	local AllImgFiles = self.m_AllImgFiles
	local ListWnd = self.mListWnd
	for _, filename in ipairs(AllImgFiles) do
		ListWnd:Insert(filename, filename)
	end
	self.mListWnd:ForceReLayout()
	
	--
	self.m_EditorFilter = ccui.EditBox:create(cc.size(400,40), "res/uiface/panels/edit_bg_4.png") 
	KE_SetParent(self.m_EditorFilter, self)
	self.m_EditorFilter:setPosition(310,225)
	local function editboxEventHandler(eventType)
		if eventType == "began" then
			-- triggered when an edit box gains focus after keyboard is shown
		elseif eventType == "ended" then
			-- triggered when an edit box loses focus after keyboard is hidden.
		elseif eventType == "changed" then
			-- triggered when the edit box text was changed.
			local string_find = string.find
			local string_lower = string.lower
			local filterStr = string_lower(self.m_EditorFilter:getText())
			self.mListWnd:RemoveAll()
			local ListWnd = self.mListWnd
			for _, filename in ipairs(self.m_AllImgFiles) do
				if string_find(string_lower(filename), filterStr) then
					ListWnd:Insert(filename, filename)
				end
			end
			self.mListWnd:ForceReLayout()
		elseif eventType == "return" then
			-- triggered when the return button was pressed or the outside area of keyboard was touched.
		end
	end
	self.m_EditorFilter:registerScriptEditBoxHandler(editboxEventHandler)
end

function clsResPanel:InitKeyBoardListener()
	--键盘事件
	local function onKeyPressed(key_code, event)
		if key_code == cc.KeyCode.KEY_UP_ARROW then
			if self:isVisible() then
				local cur_idx = self.mListWnd:GetSelectedIdx()
				if cur_idx then
					self.mListWnd:SetSelectedIdx(cur_idx-1)
				end
			end
		elseif key_code == cc.KeyCode.KEY_DOWN_ARROW then
			if self:isVisible() then
				local cur_idx = self.mListWnd:GetSelectedIdx()
				if cur_idx then
					self.mListWnd:SetSelectedIdx(cur_idx+1)
				end
			end
		end
	end
	
	local function onKeyReleased(key_code, event)
		
	end

	keyboard:AddKeyPressListener(onKeyPressed)
	keyboard:AddKeyReleaseListener(onKeyReleased)
end

