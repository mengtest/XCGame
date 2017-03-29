module("helper",package.seeall)

clsCompLoader = class("clsCompLoader")

function clsCompLoader:ctor(sCfgFile)
	self._bLoaded = false
	self._sCfgFile = sCfgFile
	self._tAllSubComps = {}
	self._tSubCompList = {}		--用于辅助安全销毁
end

function clsCompLoader:dtor()
	local subCompList = self._tSubCompList
	local cnt = #subCompList
	for i=cnt, 1, -1 do
		KE_SafeDelete(subCompList[i])
	end
	self._tSubCompList = {}
	self._tAllSubComps = {}
end

function clsCompLoader:GetAllSubComps()
	return self._tAllSubComps
end

function clsCompLoader:GetCompByName(Name)
	return self._tAllSubComps[Name]
end

function clsCompLoader:LoadByCfgFile(CompRoot)
	assert(not self._bLoaded, "不可重复加载")
	if self._bLoaded then return end
	self._bLoaded = true
	if not self._sCfgFile or self._sCfgFile=="" then return end
	
	local CfgInfo = setting.Get(self._sCfgFile)
	return self:LoadByCfgInfo(CompRoot, CfgInfo)
end

function clsCompLoader:LoadByCfgInfo(CompRoot, CfgInfo)
	local ControlName = CfgInfo.Name
	local ClassName = CfgInfo.ClassName
	local Attr = CfgInfo.Attr
	local Childrens = CfgInfo.Childrens
	
	-- 如果CompRoot不为空，则单纯将属性应用到CompRoot。 否则创建CompRoot
	if CompRoot then
		if ClassName then 
			assert(ControlName=="RootComp", "根节点须命名为RootComp") 
			helper.ApplyCompnentAttr(CompRoot, ClassName, Attr)
		end
	else
		CompRoot = helper.CreateCompnent(CfgInfo)
		self._tAllSubComps[ControlName] = CompRoot
		self._tSubCompList[#self._tSubCompList+1] = CompRoot
	end
	
	-- 创建孩子节点
	if Childrens then
		for _, Info in ipairs(Childrens) do
			self:CreateCompByCfgInfo(Info, CompRoot)
		end
	end
	
	return CompRoot
end

function clsCompLoader:CreateCompByCfgInfo(CfgInfo, Parent)
	assert(Parent, string.format("创建节点【%s】失败，父节点不存在",ControlName)) 
	local ControlName = CfgInfo.Name
	local ClassName = CfgInfo.ClassName
	local Attr = CfgInfo.Attr
	local Childrens = CfgInfo.Childrens
	assert(ControlName ~= "RootComp", "子节点不可命名为: RootComp")
	assert(not self._tAllSubComps[ControlName], string.format("重复创建相同名字的组件：%s",ControlName))
	
	-- 创建
	local NewComp = helper.CreateCompnent(CfgInfo, Parent)
	self._tAllSubComps[ControlName] = NewComp
	self._tSubCompList[#self._tSubCompList+1] = NewComp
	KE_SetParent(NewComp, Parent)
	
	-- 创建孩子节点
	if Childrens then
		for _, Info in ipairs(Childrens) do
			self:CreateCompByCfgInfo(Info, NewComp)
		end
	end
	
	return NewComp
end
