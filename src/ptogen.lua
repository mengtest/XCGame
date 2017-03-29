------------------
-- 协议生成器
------------------

local AllPTO_PATH = "src/data/protocal_define/allpto.lua"


local function GetStructFileList()
	local path_list = {}
	local StructLuaFiles = io.SearchFolderByMode("/src/data/protocal_define/datastructs", "%.lua$")
	for i, filepath in ipairs(StructLuaFiles) do
		table.insert(path_list, filepath)
	end
	return path_list
end

local function GetPtoFileList()
	local path_list = {}
	local StructLuaFiles = io.SearchFolderByMode("/src/data/protocal_define/protocals", "%.lua$")
	for i, filepath in ipairs(StructLuaFiles) do
		table.insert(path_list, filepath)
	end
	return path_list
end

local function GenAllpto()
	local fout = io.open(AllPTO_PATH, "w")
	if not fout then
		assert(false, "写入文件失败："..AllPTO_PATH)
		return
	end
	
	print("开始自动生成协议......")
	local begin_time = os.clock()
	local ALL_STRUCT_PATH = GetStructFileList()
	local ALL_PROTOCAL_PATH = GetPtoFileList()
	
	-- 写入allpto.lua
	fout:write("return {\n")
	fout:write("{\n")
	for idx, path in ipairs(ALL_STRUCT_PATH) do
		local info = io.SafeLoadFile(path)
		local StructName, StructDef = info[1], info[2]
		local strDef = table.get_table_oneline_str(StructDef)
		fout:write( string.format("[%d]={\"%s\",%s,},\n",idx,StructName,strDef) )
	end
	fout:write("},{\n");
	for idx, path in ipairs(ALL_PROTOCAL_PATH) do
		local info = io.SafeLoadFile(path)
		local ProtocalName, ProtocalDef = info[1], info[2]
		local strDef = table.get_table_oneline_str(ProtocalDef)
		fout:write( string.format("[%d]={\"%s\",%s,},\n",idx,ProtocalName,strDef) )
	end
	fout:write("}")
	fout:write("\n}")
	
	fout:close()
	
	print( "自动生成协议完成：用时 "..(os.clock()-begin_time) )
end

-----------------------------------------------------------

-- GenAllpto()
