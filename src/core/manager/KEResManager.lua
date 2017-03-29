--------------------
-- 资源管理器
--------------------
local _InstTextureCache = cc.Director:getInstance():getTextureCache()
local _InstSpriteFrameCache = cc.SpriteFrameCache:getInstance()
local _InstAnimationCache = cc.AnimationCache:getInstance()
local _InstArmatureDataMgr = ccs.ArmatureDataManager:getInstance()

--------------------分割线-------------------------

ClsResMgr = class("ClsResMgr")
ClsResMgr.__is_singleton = true

function ClsResMgr:ctor()
	self._tSprFrameInfo = {}
end

function ClsResMgr:dtor()
    _InstSpriteFrameCache:removeSpriteFrames()
    self._tSprFrameInfo = {}
end

------------------
--分割线
------------------

function ClsResMgr:ClearEngineCaches()
	cc.Director:getInstance():purgeCachedData()
	cc.Sprite3DCache:getInstance():removeAllSprite3DData()
	_InstSpriteFrameCache:removeUnusedSpriteFrames()
	_InstTextureCache:removeUnusedTextures()
	_InstAnimationCache:removeAnimation(name)
end

function ClsResMgr:PurgeCachedData()
	cc.Director:getInstance():purgeCachedData()
end

function ClsResMgr:RemoveAllSprite3DData()
	cc.Sprite3DCache:getInstance():removeAllSprite3DData()
end

function ClsResMgr:RemoveUnusedSpriteFrames()
    _InstSpriteFrameCache:removeUnusedSpriteFrames()
end

function ClsResMgr:RemoveUnusedTextures()
	_InstTextureCache:removeUnusedTextures()
end

function ClsResMgr:RemoveAnimationCache(name)
    _InstAnimationCache:removeAnimation(name)
end

------------------
--分割线
------------------

-- plistPath: "role/10001/dance.plist"
function ClsResMgr:AddSpriteFrames(plistPath)
	if self._tSprFrameInfo[plistPath] then
		self._tSprFrameInfo[plistPath] = self._tSprFrameInfo[plistPath] + 1 
		return 
	end
	self._tSprFrameInfo[plistPath] = 1
    _InstSpriteFrameCache:addSpriteFrames(plistPath)
end

-- plistPath: "role/10001/dance.plist"
function ClsResMgr:SubSpriteFrames(plistPath)
	if not plistPath or not self._tSprFrameInfo[plistPath] then return end
	self._tSprFrameInfo[plistPath] = self._tSprFrameInfo[plistPath] - 1
	if self._tSprFrameInfo[plistPath] <= 0 then
		self._tSprFrameInfo[plistPath] = nil
    	_InstSpriteFrameCache:removeSpriteFramesFromFile(plistPath)
	end
end

------------------
--分割线
------------------

-- jsonFile: "xxx.ExportJson"
function ClsResMgr:AddArmatureFileInfo(...)
	_InstArmatureDataMgr:addArmatureFileInfo(...)
end

-- jsonFile: "xxx.ExportJson"
function ClsResMgr:AddArmatureFileInfoAsync(...)
	_InstArmatureDataMgr:addArmatureFileInfoAsync(...)
end

-- jsonFile: "xxx.ExportJson"
function ClsResMgr:SubArmatureFileInfo(jsonFile)
	_InstArmatureDataMgr:removeArmatureFileInfo(jsonFile)
end
