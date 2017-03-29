local _is_check_open = true		--发布版可以关闭检查标志

-- 将要检查泄露的对象加入该表
_G.mem_leak_helper = {}
setmetatable(_G.mem_leak_helper, {__mode = "k"})

-- 记录信息
local meminfo = {}
local function _info(memstr)
	meminfo[#meminfo+1] = memstr
end

-- 以findDest为根递归搜索找到引用了对象obj的位置
local findedObjMap = nil

function _G.findObject(obj, findDest)  
	if findDest == nil then  
		return false  
	end  
	if findedObjMap[findDest] ~= nil then  
		return false  
	end  
	findedObjMap[findDest] = true  
	
	local destType = type(findDest)  
	if destType == "table" then  
		if findDest == _G.mem_leak_helper then
			return false  
		end  
		for key, value in pairs(findDest) do  
			if key == obj or value == obj then  
				_info( string.format("LEAK:   key: %s  value: %s", key, obj) ) 
				return true  
			end  
			if findObject(obj, key) == true then  
				_info("table key")  
				return true  
			end  
			if findObject(obj, value) == true then
				_info( string.format("key:[%s]",tostring(key)) )
				return true  
			end  
		end  
	elseif destType == "function" then  
		local uvIndex = 1  
		while true do  
			local name, value = debug.getupvalue(findDest, uvIndex)  
			if name == nil then  
				break  
			end  
			if findObject(obj, value) == true then  
				_info("upvalue name:["..tostring(name).."]")  
				return true  
			end  
			uvIndex = uvIndex + 1  
		end  
	end  
	return false  
end  

--
function _G.findObjectInGlobal(obj)  
    findedObjMap = {}
    setmetatable(findedObjMap, {__mode = "k"})
    _G.findObject(obj, _G)
end 

function CheckMemoryLeak()
	collectgarbage("collect")
	collectgarbage("collect")
	collectgarbage("collect")
	meminfo = {}
	for obj, dbgstr in pairs(mem_leak_helper) do
		meminfo[#meminfo+1] = string.format("++++++++++++ %s  %s", obj, dbgstr)
		findObjectInGlobal(obj)
	end
	print("-------------内存泄露检查开始-------------")
	table.print(meminfo)
	print("-------------内存泄露检查结束-------------")
	collectgarbage("collect")
	collectgarbage("collect")
	collectgarbage("collect")
end

function AddMemoryMonitor(obj)
	if _is_check_open then
		local Info = debug.getinfo(3)
		local dbgstr = string.format("文件：%s  第%s行", Info.short_src, Info.currentline)
		mem_leak_helper[obj] = dbgstr or true
	end 
end
