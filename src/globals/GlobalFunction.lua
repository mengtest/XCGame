----------------------
-- 全局函数
----------------------
local TYPE_INT 		= "number"
local TYPE_STRING 	= "string"
local TYPE_BOOL 	= "boolean"
local TYPE_TABLE 	= "table"
local TYPE_USERDATA = "userdata"
local TYPE_FUNCTION	= "function"

function is_number(obj) return type(obj) == TYPE_INT end
function is_string(obj) return type(obj) == TYPE_STRING end
function is_boolean(obj) return type(obj) == TYPE_BOOL end
function is_table(obj) return type(obj) == TYPE_TABLE end
function is_userdata(obj) return type(obj) == TYPE_USERDATA end
function is_function(obj) return type(obj) == TYPE_FUNCTION end
function is_nil(obj) return obj == nil end

TYPE_CHECKER = {
	--
	INT = function(value) assert( type(value)==TYPE_INT, "类型必须为【number】而非 "..type(value) ) end,
	STRING = function(value) assert( type(value)==TYPE_STRING, "类型必须为：【string】而非 "..type(value) ) end,
	BOOL = function(value) assert( type(value)==TYPE_BOOL, "类型必须为：【boolean】而非 "..type(value) ) end,
	TABLE = function(value) assert( type(value)==TYPE_TABLE, "类型必须为：【table】而非 "..type(value) ) end,
	USERDATA = function(value) assert( type(value)==TYPE_USERDATA, "类型必须为：【userdata】而非 "..type(value) ) end,
	FUNC = function(value) assert( type(value)==TYPE_FUNCTION, "类型必须为：【function】而非 "..type(value) ) end,
	--
	INT_NIL = function(value) assert( value==nil or type(value)==TYPE_INT, "类型必须为：【number or nil】而非 "..type(value) ) end,
	STRING_NIL = function(value) assert( value==nil or type(value)==TYPE_STRING, "类型必须为：【string or nil】而非 "..type(value) ) end,
	BOOL_NIL = function(value) assert( value==nil or type(value)==TYPE_BOOL, "类型必须为：【boolean or nil】而非 "..type(value) ) end,
	TABLE_NIL = function(value) assert( value==nil or type(value)==TYPE_TABLE, "类型必须为：【table or nil】而非 "..type(value) ) end,
	USERDATA_NIL = function(value) assert( value==nil or type(value)==TYPE_USERDATA, "类型必须为：【userdata or nil】而非 "..type(value) ) end,
	FUNC_NIL = function(value) assert( value==nil or type(value)==TYPE_FUNCTION, "类型必须为：【function or nil】而非 "..type(value) ) end,
	--
	ANY = function() end,
}

KE_GC = function()
	collectgarbage("collect")
	collectgarbage("collect")
end

function KE_CleanupMemory()
	log_warn("-------------清理内存开始-------------")
	ClsResMgr.GetInstance():ClearEngineCaches()
	KE_GC()
	log_warn("-------------清理内存结束-------------")
end

function KE_IsEditMode()
	return KE_APP_MODAL ~= 1
end

------------------------
-- 脚本层创建的对象分为以下三类
-- 1. 纯引擎对象：如 local spr = cc.Sprite:create()
-- 2. 纯脚本对象：class及其子类等，如 local g_EventMgr = clsEventSource:new()
-- 3. 同时继承了脚本对象和引擎对象的对象：local wnd = clsWindow.new()
-- 所有对象的销毁使用统一接口 KE_SafeDelete
------------------------
local tolua_isnull = tolua.isnull

function KE_SetParent(childObj, parentObj, order)
	if not childObj then return end
	if tolua_isnull(childObj) then return end
	if childObj:getParent() == parentObj then return end
	
	if parentObj == nil then
		KE_RemoveFromParent(childObj)
		assert(false, "为了方便搜索，请使用KE_RemoveFromParent")
	else
		childObj:removeFromParent(false)
		if order then
			parentObj:addChild(childObj, order)
		else
			parentObj:addChild(childObj)
		end
	end
end

-- 只在析构函数中使用，方便搜索
function KE_RemoveFromParent(childObj)
	if not childObj then return end
	if tolua_isnull(childObj) then return end
	childObj:removeFromParent()
end

-- 删除对象的统一接口
function KE_SafeDelete(obj)
	if obj then
		if obj.delete then
			obj:delete()
		elseif not tolua_isnull(obj) then 
			obj:removeFromParent()
		end
	end
end

-- 
function KE_ExtendClass(WhichClass)
	if WhichClass.HasScriptHandler then 
		assert(WhichClass.HasScriptHandler)
		assert(WhichClass.AddScriptHandler)
		assert(WhichClass.DelScriptHandler)
		assert(WhichClass.EnableNodeEvents)
		assert(WhichClass.DisableNodeEvents)
		return --已经注册过则直接返回
	else 
		assert(not WhichClass.HasScriptHandler)
		assert(not WhichClass.AddScriptHandler)
		assert(not WhichClass.DelScriptHandler)
		assert(not WhichClass.EnableNodeEvents)
		assert(not WhichClass.DisableNodeEvents)
	end
	
	function WhichClass:HasScriptHandler(func)
		if self._t_script_handler then
			for evtName, handlerList in pairs(self._t_script_handler) do
				if handlerList[func] then
					return true
				end
			end
		end
		return false 
	end
	
	function WhichClass:AddScriptHandler(evtName, func)
		self:EnableNodeEvents()
		assert(type(evtName)=="string")
		assert(type(func)=="function")
		assert(not self:HasScriptHandler(func))
		self._t_script_handler = self._t_script_handler or {}
		self._t_script_handler[evtName] = self._t_script_handler[evtName] or {}
		self._t_script_handler[evtName][func] = true
		return func
	end
	
	function WhichClass:DelScriptHandler(func)
		if self._t_script_handler then
			for evtName, handlerList in pairs(self._t_script_handler) do
				handlerList[func] = nil
			end
		end
	end
	
	function WhichClass:EnableNodeEvents()
	    if self._bIsNodeEventEnabled then return end
		self._bIsNodeEventEnabled = true
		self:registerScriptHandler(function(evtName)
			if self._t_script_handler and self._t_script_handler[evtName] then
				local handlerList = self._t_script_handler[evtName]
				for func, _ in pairs(handlerList) do 
					func()
				end 
			end 
		end)
	end
	
	function WhichClass:DisableNodeEvents()
		if not self._bIsNodeEventEnabled then return end
	    self:unregisterScriptHandler()
	    self._bIsNodeEventEnabled = false
	end
end

