------------------------
--
------------------------
local is_lua_file = function(sPath) return string.find(sPath,"%.lua$") end
local is_png_file = function(sPath) return string.find(sPath,"%.png$") end
local is_jpg_file = function(sPath) return string.find(sPath,"%.jpg$") end
local is_file = function(sPath) return string.find(sPath, ".+/([^/]*%.%w+)$") end
local is_folder = function(sPath) return not string.find(sPath, ".+/([^/]*%.%w+)$") end

io.IsFileExist = function(filePath)
	local f = io.open(filePath, "rb")
	if not f then return false end
	f:close()
	return true
end

io.GetFileContent = function(filePath)
	local f = io.open(filePath, "rb")
	if not f then return nil end
	local str = f:read("*a")
	f:close()
	return str
end

io.GetFileName = function(FileName)
	local name = string.match(FileName, ".+/([^/]*%.%w+)$")
	return string.split(name,".")[1]
end

io.StripFileName = function(FileName)
-- 	local name = string.match(FileName, “.+\\([^\\]*%.%w+)$”)
	local name = string.match(FileName, ".+/([^/]*%.%w+)$")
	local dir = string.sub(FileName, 1, string.len(FileName)-string.len(name))
	return dir, name
end

io.CreateDir = function(DirPath)
	if device.platform == "windows" then
		os.execute("mkdir \"" .. DirPath .. "\"")
	else
		os.execute("mkdir -p \"" .. DirPath .. "\"")
	end
end

io.CreateFile = function(FileName, sContent)
	local f = io.open(FileName,"w")
	if not f then 
		local dir, name = io.StripFileName(FileName)
		io.CreateDir(dir)
		f = io.open(FileName,"w")
	end
	assert(f, "create file error: "..FileName) 
	if not f then return false end
	f:write(sContent or " ")
	f:close()
	return true
end


io.SafeLoadFile = function(filename)
	local data = require(filename)
	if not data then 
		assert(false, "加载文件出错: "..filename) 
		return 
	end
	return data
end


--------------------------------------------
--
--	os.execute('dir "' .. PNG_PATH .. '" /s > temp.txt')
--	io.input("temp.txt")

local CUR_DIR_NAME = false
local LEN_CUR_DIR_NAME = 0

--只在WIN32下可用
io.GetCurDirName = function()
	assert(device.platform == "windows")
	if CUR_DIR_NAME then return CUR_DIR_NAME end
	local obj =  io.popen("cd")
	CUR_DIR_NAME = obj:read("*all"):sub(1,-2)    -- CUR_DIR_NAME存放当前路径
	obj:close()
	LEN_CUR_DIR_NAME = string.len(CUR_DIR_NAME) + 2
	return CUR_DIR_NAME
end

--只在WIN32下可用
io.SearchFolderByFilter = function(folder_name, filter_func)
	assert(device.platform == "windows")
	assert(type(folder_name)=="string","非法的文件夹名")
	assert(type(filter_func)=="function", "非法的过滤函数")
	local string_sub = string.sub
	
	local CUR_DIR_NAME = io.GetCurDirName()
	local FULL_PATH = CUR_DIR_NAME .. folder_name
	
	local TblFiles = {}
	
	local handlerFiles = io.popen("find " .. FULL_PATH .. "*") --文件夹下所有的文件夹和文件
	for file in handlerFiles:lines() do 
		if filter_func(file) then
			TblFiles[#TblFiles+1] = string_sub(file, LEN_CUR_DIR_NAME)
		end
	end
	handlerFiles:close()
	
	return TblFiles
end

--只在WIN32下可用
io.SearchFolderByMode = function(folder_name, mode_str)
	assert(device.platform == "windows")
	assert(type(folder_name)=="string","非法的文件夹名")
	assert(type(mode_str)=="string", "非法的模式字符串")
	local string_sub = string.sub
	local string_find = string.find
	
	local CUR_DIR_NAME = io.GetCurDirName()
	local FULL_PATH = CUR_DIR_NAME .. folder_name
	
	local TblFiles = {}
	
	local handlerFiles = io.popen("find " .. FULL_PATH .. "*") --文件夹下所有的文件夹和文件
	for file in handlerFiles:lines() do 
		if string_find(file, mode_str) then
			TblFiles[#TblFiles+1] = string_sub(file, LEN_CUR_DIR_NAME)
		end
	end
	handlerFiles:close()
	
	return TblFiles
end
--
-----------------------------------------