----------------------
-- 辅助库
----------------------
module("utils", package.seeall)

function IsWhiteSpace(Str)
	return not string.find(Str, "%S")
end

function IsValidVarName(Name)
	if utils.IsWhiteSpace(Name) or string.gsub(Name, "[_%a][_%w]*", "") ~= "" then
		return false
	end
	return true
end

--敏感字检测
function SensitiveCheck(Str)
	local Forbidden = setting.T_filter_cfg.Forbidden
	
	Str = string.lower(Str)
	Str = string.gsub(Str, "[%w%c%s%p]+","")	--去除ASCII字符再进行判断
	
	local string_find = string.find 
	for _, s in pairs(Forbidden) do
		if string_find(Str, s, 1, true) then
			return false
		end
	end

	return true
end

--用户名检测
function IsValidUserName(Str)
	if IsWhiteSpace(Str) then 
		return false, "不可全为空白字符"
	end
	
	if not SensitiveCheck(Str) then 
		return false, "您输入了不合规定的字符"
	end
	
	return true 
end

-- 随机昵称
local UsedKey = {}
function GenUserName(sex)
	assert(sex=="Boy" or sex=="Girl", sex)
	local NameLib = T_filter_cfg.NameLib
	local FirstNameTbl = NameLib.FirstName[sex]
	local SecondNameTbl = NameLib.SecondName[sex]
	local FullName 
	while not FullName do
		local key1, key2 = math.random(1, #FirstNameTbl), math.random(1,#SecondNameTbl)
		local key = key1.."_"..key2
		if not UsedKey[key] then
			UsedKey[key] = true
			FullName = FirstNameTbl[key1] .. SecondNameTbl[key2]
		end
	end
	return FullName
end