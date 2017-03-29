----------------------
-- 调试
----------------------
--详细的traceback
function __G__TRACKBACK__(e)
	print("----------------------------------")
	
	local max_level = 0
	while true do
		local info = debug.getinfo(max_level + 1, "n")
		if not info then break end
		max_level = max_level + 1
	end
	
	local btinfo = {}
	table.insert(btinfo, tostring(e))
--	table.insert(btinfo, debug.traceback())
	for level = 2, max_level do
		local info = debug.getinfo(level, 'nfSlu')
		assert(info)
		if info.what == "C" then
			if info.name ~= nil then
				table.insert(btinfo, string.format('\t<%2d> [C] : in %s', level - 1, info.name))
			else
				table.insert(btinfo, string.format('\t<%2d> [C] :', level - 1))
			end
		else
			if info.name ~= nil then
				table.insert(btinfo , string.format('\t<%2d> %s:%d in %s', level - 1, info.source, info.currentline, info.name))
			else
				table.insert(btinfo, string.format('\t<%2d> %s:%d', level - 1, info.source, info.currentline))
			end
			
			if info.func then
				local i = 1
				while true do
					local name, value = debug.getupvalue(info.func, i)
					if not name then break end
					table.insert(btinfo, string.format("\t\t %s : %s",
						type(name) == "string" and string.format("\"%s\"",name) or tostring(name),
						type(value) == "string" and string.format("\"%s\"",value) or tostring(value)))
					i = i + 1
				end
			end
			
			local i = 1
			while true do
				local name, value = debug.getlocal(level, i)
				if not name then break end
				table.insert(btinfo, string.format("\t\t %s : %s",
					type(name) == "string" and string.format("\"%s\"",name) or tostring(name),
					type(value) == "string" and string.format("\"%s\"",value) or tostring(value)))
				i = i + 1
			end
		end
	end

	print(table.concat(btinfo, "\n"))
	print("----------------------------------")
end


function log_normal(...)
	print(...)
end

function log_warn(...)
	print(...)
end

function log_error(...)
	print(...)
end

function log_2_file(str, path)
	if not str or str == "" then return end
	path = path or ("F:/lua_log.txt")
	local f = io.open(path, "a+")
	if not f then return end
	f:write(str.."\n")
	f:close()
end

local obj_counter = {}
function CountObject(clsName, inc)
	assert(is_string(clsName))
	assert(inc==1 or inc==-1)
	obj_counter[clsName] = obj_counter[clsName] or 0
	obj_counter[clsName] = obj_counter[clsName] + inc
end

function DumpObjectCounter()
	for name, count in pairs(obj_counter) do
		print("----", name, count)
	end
end

function DumpDebugInfo()
	print("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
	
	print("*************** 纹理缓存 ***************")
	print( cc.Director:getInstance():getTextureCache():getCachedTextureInfo() )
	
	print("*************** LUA内存占用 ***************")
	print( string.format("%fM", collectgarbage("count")/1000) )

	print("*************** 对象计数 ***************")
	DumpObjectCounter()
	
	print("*************** 定时器 *****************")
	ClsTimerMgr.GetInstance():DumpDebugInfo()
	
	print("*************** 小红点 *****************")
	redpoint.ClsRedPointManager.GetInstance():DumpDebugInfo()
	
	print("*************** 物理世界 ***************")
	ClsPhysicsWorld.GetInstance():DumpDebugInfo()
	
	print("*************** 串行动画 ***************")
	procedure.ClsProcedureMgr.GetInstance():DumpDebugInfo()
	
	print("*************** 任务列表 ***************")
	if KE_Director:GetHero() and KE_Director:GetHero():GetAiBrain() then
		KE_Director:GetHero():GetAiBrain():DumpDebugInfo()
	end
	
	print("*************** UI界面 ***************")
	if KE_Director:GetUIMgr() then
		KE_Director:GetUIMgr():DumpDebugInfo()
	end
	
	print("*************** 功能系统热度 ***************")
	ClsSystemMgr.GetInstance():DumpDebugInfo()
	
	print("*************** 类定义信息 ***************")
	print("定义的类数量：", table.size(GetAllClass()))
	
	print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
end
