-------------------
-- XTree对象的上下文管理
-------------------
module("actree",package.seeall)

clsXContext = class("clsXContext")

function clsXContext:ctor()
	self.tAllRoles = {}
	self.tAllEffects = {}
	self.tAllPanels = {}
	self.tAllMissiles = {}
	self.tAllAtoms = {}			--所有创建的元素，包括角色、特效、面板、子弹
	self.tPerformerTable = {}	--演员表
	self.tAtomIdTable = {}		--元素表，记录所有元素ID，方便决定哪个Atom由某对象来扮演
	self.tAutoDelAtoms = {}		--播放完毕后，需要销毁的元素ID列表
end

function clsXContext:dtor()
	for _, atom_id in ipairs(self.tAutoDelAtoms) do
		self:DestroyAtom(atom_id)
	end
end


function clsXContext:CreateXRole(atom_id, TypeId)
	assert(not self.tAllAtoms[atom_id], "重复创建相同ID的角色: "..atom_id)
	
	local performer = self:GetPerFormer(atom_id)
	if performer then
		self.tAllAtoms[atom_id] = performer
		self.tAllRoles[atom_id] = performer
		log_warn("滴滴滴滴 演员就位", atom_id)
		return performer
	end
	
	self.tAllAtoms[atom_id] = ClsRoleMgr.GetInstance():CreateTempRole(TypeId)
	self.tAllRoles[atom_id] = self.tAllAtoms[atom_id]
	return self.tAllAtoms[atom_id]
end

function clsXContext:CreateXEffect(atom_id, res_path)
	assert(not self.tAllAtoms[atom_id], "重复创建相同ID的特效: "..atom_id)
	
	local performer = self:GetPerFormer(atom_id)
	if performer then
		self.tAllAtoms[atom_id] = performer
		self.tAllEffects[atom_id] = performer
		log_warn("滴滴滴滴 演员就位", atom_id)
		return performer
	end
	
	self.tAllAtoms[atom_id] = ClsEffectMgr.GetInstance():CreateEffectSeq(atom_id, res_path)
	self.tAllEffects[atom_id] = self.tAllAtoms[atom_id]
	return self.tAllAtoms[atom_id]
end

function clsXContext:CreateXPanel(atom_id, res_path)
	assert(not self.tAllAtoms[atom_id], "重复创建相同ID的面板: "..atom_id)
	
	local performer = self:GetPerFormer(atom_id)
	if performer then
		self.tAllAtoms[atom_id] = performer
		self.tAllPanels[atom_id] = performer
		log_warn("滴滴滴滴 演员就位", atom_id)
		return performer
	end
	
	self.tAllAtoms[atom_id] = ui.clsWindow.new(nil, "src/data/uiconfigs/ui_dialog/confirm_dlg.lua")
	self.tAllPanels[atom_id] = self.tAllAtoms[atom_id]
	KE_SetParent(self.tAllAtoms[atom_id], KE_Director:GetLayerMgr():GetLayer(const.LAYER_PANEL))
	return self.tAllAtoms[atom_id]
end

function clsXContext:CreateXMissile(atom_id, theOwner, cfg_info)
	assert(not self.tAllAtoms[atom_id], "重复创建相同ID的子弹: "..atom_id)
	
	self.tAllAtoms[atom_id] = missile.ClsMissileMgr.GetInstance():CreateMissile(theOwner, cfg_info)
	self.tAllMissiles[atom_id] = self.tAllAtoms[atom_id]
	self.tAllAtoms[atom_id]:BeginFly(function()
		self.tAllAtoms[atom_id] = nil
		self.tAllMissiles[atom_id] = nil
	end)
	return self.tAllAtoms[atom_id]
end


function clsXContext:DestroyXRole(atom_id)
	if self.tAllRoles[atom_id] then
		ClsRoleMgr.GetInstance():DestroyTempRole(self.tAllRoles[atom_id])
		self.tAllRoles[atom_id] = nil
		self.tAllAtoms[atom_id] = nil
	end
end

function clsXContext:DestroyXEffect(atom_id)
	if self.tAllEffects[atom_id] then
		ClsEffectMgr.GetInstance():DestroyEffect(atom_id)
		self.tAllEffects[atom_id] = nil
		self.tAllAtoms[atom_id] = nil
	end
end

function clsXContext:DestroyXPanel(atom_id)
	if self.tAllPanels[atom_id] then
		KE_SafeDelete(self.tAllPanels[atom_id])
		self.tAllPanels[atom_id] = nil
		self.tAllAtoms[atom_id] = nil
	end
end

function clsXContext:DestroyXMissile(atom_id)
	if self.tAllMissiles[atom_id] then
		missile.ClsMissileMgr.GetInstance():DestroyMissile(atom_id)
		self.tAllMissiles[atom_id] = nil
		self.tAllAtoms[atom_id] = nil
	end
end

function clsXContext:DestroyAtom(atom_id)
	self:DestroyXRole(atom_id)
	self:DestroyXEffect(atom_id)
	self:DestroyXPanel(atom_id)
	self:DestroyXMissile(atom_id)
end


function clsXContext:SetAutoDelAtoms(tAutoDelList)
	assert(tAutoDelList==nil or table.is_array(tAutoDelList), "参数错误")
	self.tAutoDelAtoms = tAutoDelList or {}
end

function clsXContext:AddAutoDelAtom(atom_id)
	table.insert(self.tAutoDelAtoms, atom_id)
end

function clsXContext:GetAtom(atom_id)
	if not self.tAtomIdTable[atom_id] then
		assert(false, "剧情文件中没有配置该atom_id: " .. atom_id .. ", 请检查配置是否正确")
		return nil
	end
	
	if self.tPerformerTable[atom_id] then 
		return self.tPerformerTable[atom_id]
	end
	
	return self.tAllAtoms[atom_id]
end
clsXContext.GetXRole = clsXContext.GetAtom
clsXContext.GetXEffect = clsXContext.GetAtom
clsXContext.GetXPanel = clsXContext.GetAtom
clsXContext.GetXMissile = clsXContext.GetAtom

function clsXContext:MarkAtomId(atom_id)
	if atom_id == nil then return end
	self.tAtomIdTable[atom_id] = atom_id
end

function clsXContext:HasAtomId(atom_id)
	return self.tAtomIdTable[atom_id] ~= nil
end

------------------------
-- 演员表
------------------------

-- 由obj来演角色atom_id
-- 注意：在播放前设置演员
function clsXContext:SetPerformer(atom_id, obj)
	if not self.tAtomIdTable[atom_id] then
		assert(false, "剧情文件中没有配置该atom_id: " .. atom_id .. ", 请检查配置是否正确")
		return false
	end
	if not obj then
		assert(false, "无效的对象")
		return false
	end
	if self.tPerformerTable[atom_id] and self.tPerformerTable[atom_id]~=obj then
		assert(false, "已经有人来演："..atom_id)
		return false
	end
	
	self.tPerformerTable[atom_id] = obj
	return true
end

function clsXContext:GetPerFormer(atom_id)
	return self.tPerformerTable[atom_id]
end

function clsXContext:HasPerformer(obj)
	for atom_id, atom in pairs(self.tPerformerTable) do
		if atom == obj then
			return true, atom_id
		end
	end
	return false
end


function clsXContext:DumpDebugInfo()
	log_warn("--------演员表 BEGIN---------")
	for atom_id, _ in pairs(self.tAtomIdTable) do
		log_warn(atom_id, "----->", self.tPerformerTable[atom_id])
	end
	log_warn("--------演员表 END---------")
end
