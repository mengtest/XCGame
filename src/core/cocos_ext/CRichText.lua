local tonumber = tonumber
local string_gsub = string.gsub
local string_format = string.format
local string_sub = string.sub

--[[
text_part = {
	ctrl_code = o,
	ctrl_text = "res/uiface/buttons/btn_close.png",
	text = "",
}
]]--
local cmd_parse_text_part = {
	--颜色
	["c"] = function(self, text_part)
		local ctrl_text = text_part.ctrl_text
		local a,r,g,b = math.Hex2ARGB(ctrl_text)
		self._CurFontColor = cc.c3b(r,g,b)
		self._CurFontAlpha = a
	end,
	--换行
	["r"] = function(self, text_part)
		local re = ccui.RichElementNewLine:create(0, cc.c3b(255, 255, 255),255)
		self:PushElement(re)
	end,
	--图片
	["o"] = function(self, text_part)
		local respath 
		local text = text_part.ctrl_text
		local img_info = string.split(text,":")
		if img_info[1] == "item" then
			local item_type = tonumber(img_info[2])
			respath = setting.GetItemImgPath(item_type)
		else
			respath = img_info[1]
		end
		assert(respath, "解析失败："..text)
		local re = ccui.RichElementImage:create(0, cc.c3b(255, 255, 255), 255, respath)
		self:PushElement(re)
	end,
	--点击事件
	["e"] = function(self, text_part)
		
	end,
	--下划线
	["u"] = function(self, text_part)
		
	end,
	--终止上一个控制符的功能
	["n"] = function(self, text_part)
		self._CurFontName = self._FontName
		self._CurFontSize = self._FontSize
		self._CurFontColor = self._FontColor
		self._CurFontAlpha = self._FontAlpha
	end,
	--显示#用，#会插入到下一个text_part中，故这里设为空函数即可
	["t"] = function(self, text_part)
		
	end,
	--字体
	["f"] = function(self, text_part)
		local ctrl_text = text_part.ctrl_text
		local info_list = string.split(ctrl_text,",")
		self._CurFontName = info_list[1]
		self._CurFontSize = tonumber(info_list[2])
	end,
	--
	[""] = function(self, text_part)
		local text = text_part.text
		if text then
			local re = ccui.RichElementText:create(0, self._CurFontColor, self._CurFontAlpha, text, self._CurFontName, self._CurFontSize)
			self:PushElement(re)
		end
	end,
}


clsRichText = class("clsRichText", function() return ccui.RichText:create() end)

function clsRichText:ctor(parent, MaxWidth, MaxHeight, FontName, FontSize, FontColor, FontAlpha)
	assert(MaxWidth and MaxHeight)
	if parent then KE_SetParent(self, parent) end
	self:ignoreContentAdaptWithSize(false)
	self:setContentSize(cc.size(MaxWidth, MaxHeight))
	
	self._FontName = FontName or "fonts/FZY4JW.TTF"
	self._FontSize = FontSize or 24
	self._FontColor = FontColor or cc.c3b(255, 255, 255)
	self._FontAlpha = FontAlpha or 255
	
	self._CurFontName = self._FontName
	self._CurFontSize = self._FontSize
	self._CurFontColor = self._FontColor
	self._CurFontAlpha = self._FontAlpha
	
	self._sText = ""
	self._AllElements = {}
end

function clsRichText:dtor()
	self:ClearElements()
	KE_RemoveFromParent(self)
end

function clsRichText:PushElement(element)
	table.insert(self._AllElements, element)
	self:pushBackElement(element)
end

function clsRichText:InsertElement(element, idx)
	table.insert(self._AllElements, idx, element)
	self:insertElement(element, idx)
end

function clsRichText:RemoveElement(idx)
	table.remove(self._AllElements, idx)
	self:removeElement(idx)
end

function clsRichText:ClearElements()
	local cnt = #self._AllElements
	for i=cnt,1,-1 do
		self:removeElement(self._AllElements[i])
	end
	self._AllElements = {}
end

function clsRichText:SetFontInfo(fontName, fontSize, fontColor, fontAlpha)
	self._FontName = fontName or self._FontName
	self._FontSize = fontSize or self._FontSize
	self._FontColor = fontColor or self._FontColor
	self._FontAlpha = fontAlpha or self._FontAlpha
end

-- #n #cFFAA88EE, #fHelvetica, #d32, #pres/icons/money.png, #xCustomNode
function clsRichText:setString(sTxt)
	sTxt = sTxt or ""
	if self._sText == sTxt then return end
	self._sText = sTxt
	self:ClearText()
	self:AddText(sTxt)
end

function clsRichText:ClearText()
	self._sText = ""
	self:ClearElements()
end

function clsRichText:AddText(txt)
	if txt == nil or txt == "" then return end
	self._sText = string.format("%s%s", self._sText,txt)

	local text_parts = self:CreateTextPartsByCtrlCode(txt)
--	table.print(text_parts)
	
	for _, text_part in ipairs(text_parts) do
		local ctrl_code = text_part.ctrl_code
		local parse_func = cmd_parse_text_part[ctrl_code]
		
		if parse_func then
			parse_func(self, text_part)
		else
			local ctrl_text = text_part.ctrl_text
			local text = text_part.text
			local str = string.format("#%s(%s)%s", ctrl_code, ctrl_text, text)
			local re = ccui.RichElementText:create(0, self._CurFontColor, self._CurFontAlpha, str, self._CurFontName, self._CurFontSize)
			self:PushElement(re)
		end
	end
end


-----------------------------------------------------------------------------
-- 解析传入的text，根据控制字符，把文本按功能段类型拆分开来
-- 通用格式为：#x(xxxx)
-- 控制字符的基础功能现有一下这些：
-- 1、#c(ffffffff)							（表示设置文字颜色为0xffffffff）
-- 2、#r()									（换行）
-- 3、#o(obj_id)							（用来在文本中显示图片，obj_id表示图片信息，利用此信息来创建图片）
-- 4、#e(click_id)点击这里#e()				（可点击字符串，click_id为程序使用）
-- 5、#u()									（下划线）
-- 6、#n()									（终止上一个控制字符的功能，可终止的类型有:#C(ffffffff)、#u）（注意：仅是终止上一个的功能，相当于出栈一个控制功能）
-- 7、#f(name,size,bold)					（设置字体）
-- 8、#t()									（"#"转为字符显示）

-- 高级控制字符：（做法是先转换为上述的基础功能格式，再进行功能实现）
-- 1、#R/#G/#B/#Y/#W
-- 2、#r/#u/#n/#t
-----------------------------------------------------------------------------

local color_map = {
	["R"] = "ffff0000",
	["G"] = "ff00ff00",
	["B"] = "ff0000ff",
	["Y"] = "ffffff00",
	["P"] = "ffff00ff",
	["W"] = "ffffffff",
	["O"] = "ffdb7549",
}
local color_mode = "#[RGBYPWO]"		-- #R #G #B #Y #P #W #O
local base_codes = "nrtu"			-- #n #r #u #t
-- 转换一些高级的控制字符串为基础控制字符串格式
function clsRichText:_transfer_ctrl_code(text)
	-- #R #G #B #Y #P #W #O
	text = string_gsub(text, color_mode, function(color_code)
		return string_format("#c(%s)", color_map[string_sub(color_code, 2, -1)])
	end)
	
	-- #n #r #u #t
	local base_mode1 = "#(["..base_codes.."])"
	local base_mode2 = "#(["..base_codes.."])%(%)"
	text = string_gsub(text, base_mode2, function(base_code)
		return string_format("#%s", base_code)
	end)
	text = string_gsub(text, base_mode1, function(base_code)
		return string_format("#%s()", base_code)
	end)
	
	return text
end

function clsRichText:CreateTextPartsByCtrlCode(text)
	text = self:_transfer_ctrl_code(text)

	text = string_format("%s#",text)
	if string_sub(text, 1, 1) ~= "#" then
		text = string_format("#def()%s",text)
	end

	local text_parts = {}

	-- #(%a+)%((.-)%)([^#]*)的解释：
	-- #：控制符以#开头
	-- (%a+)：ctrl_code为所有字母(1~多个)
	-- %((.-)%)：ctrl_text为被()包起来的，最短的任意字符集合(0~多个)
	-- ([^#]*)：str为最长的不包含#号的任意字符集合(0~多个)，注意这里不能用：(.-)#，这个会把后面的#号吃掉，导致下一个控制字符无效
	for ctrl_code, ctrl_text, str in string.gmatch(text, "#(%a+)%((.-)%)([^#]*)") do
		-- 先将控制字符当做单独的text_part加入
		if ctrl_code ~= "def" then
			text_parts[#text_parts+1] = {
				ctrl_code = ctrl_code,
				ctrl_text = ctrl_text,
				text = "",
			}
		end
		
		-- 再将需要显示的字符串当做text_part加入
		if ctrl_code == "t" then
			text_parts[#text_parts+1] = {
				ctrl_code = "",
				ctrl_text = "",
				text = "#",
			}
		end
		
		if str ~= "" then
			text_parts[#text_parts+1] = {
				ctrl_code = "",
				ctrl_text = "",
				text = str,
			}
		end
	end

	return text_parts
end
