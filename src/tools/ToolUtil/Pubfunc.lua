-------------------
--公用接口
-------------------
module("ToolUtil", package.seeall)

function NewPropItem(Info, Parent, Wid, Hei, Callback)
	local PropItem
	local PropName = Info.PropName
	local PropType = Info.PropType
	
	if PropType == "int" then
		PropItem = ccui.EditBox:create(cc.size(Wid,Hei), "res/uiface/panels/edit_bg_4.png") 
		PropItem:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
		
		PropItem.setValueStr = PropItem.setText
		PropItem.getValueStr = PropItem.getText
		
		local function editboxEventHandler(eventType)
			if eventType == "return" then
				Callback(PropName, PropItem:getText())
			end
		end
		PropItem:registerScriptEditBoxHandler(editboxEventHandler)
		
	elseif PropType == "float" then
		PropItem = ccui.EditBox:create(cc.size(Wid,Hei), "res/uiface/panels/edit_bg_4.png") 
		PropItem:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
		
		PropItem.setValueStr = PropItem.setText
		PropItem.getValueStr = PropItem.getText
		
		local function editboxEventHandler(eventType)
			if eventType == "return" then
				Callback(PropName, PropItem:getText())
			elseif eventType == "changed" then
				if not(tonumber(PropItem:getText())) then
					PropItem:setText("")
				end
			end
		end
		PropItem:registerScriptEditBoxHandler(editboxEventHandler)
		
	elseif PropType == "string" then
		PropItem = ccui.EditBox:create(cc.size(Wid,Hei), "res/uiface/panels/edit_bg_4.png") 
		PropItem:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
		
		PropItem.setValueStr = PropItem.setText
		PropItem.getValueStr = PropItem.getText
		
		local function editboxEventHandler(eventType)
			if eventType == "return" then
				Callback(PropName, PropItem:getText())
			end
		end
		PropItem:registerScriptEditBoxHandler(editboxEventHandler)
		
	elseif PropType == "boolean" then
		PropItem = ccui.Button:create("res/uiface/panels/edit_bg_4.png") 
		PropItem:setScale9Enabled(true)
		PropItem:setContentSize(Wid,Hei)
		
		PropItem.setValueStr = PropItem.setTitleText
		PropItem.getValueStr = PropItem.getTitleText
		
		PropItem:setValueStr("是")
		PropItem:addTouchEventListener(function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				if PropItem:getValueStr() == "是" then
					PropItem:setValueStr("否")
				else 
					PropItem:setValueStr("是")
				end 
				Callback(PropName, PropItem:getValueStr())
			end 
		end)
	
	elseif PropType == "point" then
		PropItem = ccui.EditBox:create(cc.size(Wid,Hei), "res/uiface/panels/edit_bg_4.png") 
		PropItem:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
		
		PropItem.setValueStr = PropItem.setText
		PropItem.getValueStr = PropItem.getText
		
		local function editboxEventHandler(eventType)
			if eventType == "return" then
				Callback(PropName, PropItem:getText())
			elseif eventType == "changed" then
				local ValueStr = PropItem:getText()
				local tbl = string.split(ValueStr,",")
				if #tbl > 2 then
					PropItem:setText(tbl[1]..","..tbl[2])
				end
				if not tonumber(tbl[1]) then
					PropItem:setText("")
				elseif tbl[2] and not tonumber(tbl[2]) then
					PropItem:setText(tbl[1]..",")
				end
			end
		end
		PropItem:registerScriptEditBoxHandler(editboxEventHandler)
		
	elseif PropType == "color" then
		PropItem = ccui.EditBox:create(cc.size(Wid,Hei), "res/uiface/panels/edit_bg_4.png") 
		PropItem:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
		
		PropItem.setValueStr = PropItem.setText
		PropItem.getValueStr = PropItem.getText
		
		local function editboxEventHandler(eventType)
			if eventType == "return" then
				Callback(PropName, PropItem:getText())
			end
		end
		PropItem:registerScriptEditBoxHandler(editboxEventHandler)
		
	elseif PropType == "image" then
		PropItem = ccui.Button:create("res/uiface/panels/edit_bg_4.png") 
		PropItem:setScale9Enabled(true)
		PropItem:setContentSize(Wid,Hei)
		
		PropItem.setValueStr = PropItem.setTitleText
		PropItem.getValueStr = PropItem.getTitleText
		
		PropItem:addTouchEventListener(function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				local wnd = ClsUIManager.GetInstance():ShowDialog("clsResPanel", function() 
					ClsUIManager.GetInstance():HideWindow("clsResPanel") 
				end)
				wnd:setPosition(GAME_CONFIG.DESIGN_W-600,GAME_CONFIG.DESIGN_H/2)
				wnd:_FixMaskPos()
				wnd:Reset(function(imgPath)
					PropItem:setTitleText(imgPath)
					Callback(PropName, imgPath)
				end)
			end 
		end)
		
	else 
		assert(false, "未知的属性值数据类型："..PropType)
	end
	
	Parent:addChild(PropItem)
	
	local LabelDesc = cc.Label:createWithTTF(const.DEF_FONT_CFG(), Info.Desc) 
	PropItem:addChild(LabelDesc)
	LabelDesc:setAnchorPoint(cc.p(1,0.5))
	LabelDesc:setPosition(-5, Hei/2)
	
	return PropItem
end
