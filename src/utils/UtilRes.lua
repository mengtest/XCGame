--------------------
-- 辅助库
--------------------
module("utils", package.seeall)

local _InstTextureCache = cc.Director:getInstance():getTextureCache()
local _InstSpriteFrameCache = cc.SpriteFrameCache:getInstance()
local _InstAnimationCache = cc.AnimationCache:getInstance()
local _InstArmatureDataMgr = ccs.ArmatureDataManager:getInstance()


function CreateObject(sResType, sResPath, ...)
	assert(sResType, "特效类型参数无效")
	assert(sResPath, "特效路径参数无效")
	local obj 
	
	if sResType == "EffectQuad" then
		obj = ClsEffectMgr.GetInstance():NewEffectQuad(sResPath, ...)
	elseif sResType == "EffectSeq" then
		obj = ClsEffectMgr.GetInstance():NewEffectSeq(sResPath, ...)
	elseif sResType == "Sprite" then
		obj = cc.Sprite:create(sResPath)
	end
	
	assert(obj, string.format("创建对象失败：%s, %s",sResType,sResPath))
	return obj
end

-- 创建粒子特效
--@param    pos_type    cc.POSITION_TYPE_GROUPED,cc.POSITION_TYPE_RELATIVE,cc.POSITION_TYPE_FREE 
function NewParticleSystemQuad(parent, res_path, pos_type, loop_times, callback)
	local emitter = cc.ParticleSystemQuad:create(res_path)
	emitter:setPositionType(pos_type)
	emitter:setAutoRemoveOnFinish(true)
	emitter:registerScriptHandler(function(state)
		if state == "cleanup" then
			if callback then callback() end
		end
	end)
	if parent then KE_SetParent(emitter,parent) end
	return emitter
end

-- 创建序列帧动画
function NewSeqFrameEffect(parent, res_path, loop_times, callback)
	local EffName = io.GetFileName(res_path)
	assert(EffName, "解析特效名失败："..res_path)
	
	ClsResMgr.GetInstance():AddSpriteFrames(res_path)
	
	local aniFrames = {}
	local frameIdx = 0
	while true do
		local frameName = string.format("%s_%d.png", EffName, frameIdx)
	    local spriteFrame = _InstSpriteFrameCache:getSpriteFrame(frameName)
		if not spriteFrame then break end
		aniFrames[#aniFrames+1] = spriteFrame
		frameIdx = frameIdx + 1
	end
	
	local iTotalFrame = #aniFrames
	assert(iTotalFrame>0, "无效的特效：总帧数小于1"..iTotalFrame)
	
	local obj = cc.Sprite:create()
	obj.iTotalFrame = iTotalFrame
	
	if parent then KE_SetParent(obj,parent) end
	
	obj:registerScriptHandler(function(state)
		if state == "cleanup" then
			ClsResMgr.GetInstance():SubSpriteFrames(res_path)
		end
	end)
	
	local animation = cc.Animation:createWithSpriteFrames(aniFrames, 0.08, loop_times)
   	obj:runAction(cc.Sequence:create(
   		cc.Animate:create(animation), 
   		cc.CallFunc:create(function()
   			if callback then callback() end
   			KE_SafeDelete(obj)
   			obj = nil 
   		end)
   	))
   	
   	return obj
end

function NewModel(Parent, fileName)
	local spr3d = cc.Sprite3D:create(fileName)
	KE_SetParent(spr3d, Parent)
	spr3d:setGlobalZOrder(1)
	return spr3d
end

function NewSprite(Parent, ResPath)
	assert(Parent, "未设置父节点")
	local newobj = cc.Sprite:create(ResPath)
	if not newobj then
		error(string.format("加载图片失败：%s", ResPath))
		return 
	end
	KE_SetParent(newobj, Parent)
	return newobj
end

function NewScale9Sprite(Parent, ResPath)
	assert(Parent, "未设置父节点")
	local newobj = cc.Scale9Sprite:create(ResPath)
	if not newobj then
		error(string.format("加载图片失败：%s", ResPath))
		return 
	end
	KE_SetParent(newobj, Parent)
	return newobj
end

function NewLayout(Parent, ResPath)
	assert(Parent, "未设置父节点")
	local newobj = ccui.Layout:create()
	if not newobj then
		error(string.format("加载图片失败：%s", ResPath))
		return 
	end
	KE_SetParent(newobj, Parent)
	return newobj
end 

function NewButton(Parent, imgNormal, imgSelected, imgDisable, OnClick)
	assert(Parent, "未设置父节点")
	local newobj = ccui.Button:create(imgNormal, imgSelected, imgDisable)
	if not newobj then
		error(string.format("创建按钮失败：%s, %s, %s", imgNormal, imgSelected, imgDisable))
		return 
	end
	KE_SetParent(newobj, Parent)
	
	if OnClick then
		utils.RegButtonEvent(newobj, OnClick)
	end
	
	return newobj
end

function NewRadioButton(Parent, imgUnselected, imgSelected)
	assert(Parent, "未设置父节点")
	local newobj = ccui.RadioButton:create(imgUnselected, imgSelected) 
	if not newobj then
		error(string.format("加载图片失败：%s, %s", imgUnselected, imgSelected))
		return 
	end
	KE_SetParent(newobj, Parent)
	return newobj
end 

function NewLoadingBar(Parent, ResPath, iPercentage)
	assert(Parent, "未设置父节点")
	local newobj = ccui.LoadingBar:create(ResPath, iPercentage) 
	if not newobj then
		error(string.format("加载图片失败：%s", ResPath))
		return 
	end
	KE_SetParent(newobj, Parent)
	return newobj
end

function NewEditor(Parent, wid, hei, imgNormal)
	assert(Parent, "未设置父节点")
	local newobj = ccui.EditBox:create(cc.size(wid,hei), imgNormal) 
	if not newobj then
		error(string.format("加载图片失败：%s", imgNormal))
		return 
	end
	KE_SetParent(newobj, Parent)
	return newobj
end 

function NewRichText(Parent, sContent)
	assert(Parent, "未设置父节点")
	local fontcfg = const.DEF_FONT_CFG()
	local newobj = cc.Label:createWithTTF(fontcfg, sContent or "") 
	if not newobj then
		error(string.format("创建富文本失败：%s", sContent or ""))
		return 
	end
	KE_SetParent(newobj, Parent)
	return newobj
end
