----------------------
-- 场景管理器
----------------------
local SCENE_CFG = {}

-- scenekey = ""
-- info = { clsname, scene_id, map_id }
function REG_SCENE_CFG(scenekey, info)
	assert(type(scenekey)=="string", "scenekey must be string")
	assert(not SCENE_CFG[scenekey], string.format("已经注册过该场景类：%s",scenekey))
	assert(info.clsname, string.format("未定义的场景类：%s",scenekey))
	SCENE_CFG[scenekey] = info
end


ClsSceneMgr = class("ClsSceneMgr")
ClsSceneMgr.__is_singleton = true

function ClsSceneMgr:ctor()
	self._mCurScene = nil
	self._sCurSceneName = nil
	self._sPreSceneName = nil
	self.bSwitching = false
	self.bIsLoading = false
end

function ClsSceneMgr:dtor()
	if self._mCurScene then
		self._mCurScene:OnDestroy()
	end
end

function ClsSceneMgr:IsSwitching() return self.bSwitching end
function ClsSceneMgr:GetCurScene() return self._mCurScene end
function ClsSceneMgr:GetCurSceneName() return self._sCurSceneName end
function ClsSceneMgr:GetPreSceneName() return self._sPreSceneName end

function ClsSceneMgr:RunScene(SceneObj)
	local theDirector = cc.Director:getInstance()
	if theDirector:getRunningScene() then
	    theDirector:replaceScene(SceneObj)
	else
	    theDirector:runWithScene(SceneObj)
	end
end

function ClsSceneMgr:Turn2Scene(scene_name, OnLoadingOver)
	assert(SCENE_CFG[scene_name], "未配置的场景："..scene_name)
	assert(not self.bSwitching, "禁止嵌套调用Turn2Scene")
	if self.bSwitching then return end
	self.bSwitching = true
	
	local sceneInfo = SCENE_CFG[scene_name]
	local scene_cls = sceneInfo.clsname
	local scene_id, map_id = sceneInfo.scene_id, sceneInfo.map_id
	
	if not scene_cls then
		self.bSwitching = false
		assert(false, "场景类不存在："..scene_name)
		return
	end
	
	-- 显示Loading界面
--	self:ShowLoading(OnLoadingOver)
	
	-- 销毁旧场景资源
	self._sPreSceneName = self._sCurSceneName
	FireGlobalEvent("LEAVE_SCENE")
	if self._mCurScene then
		self._mCurScene:OnDestroy()
	end
	
	-- 清理内存
	KE_CleanupMemory()
	
	log_warn("离开场景:", self._sPreSceneName)
	log_warn("进入场景:", scene_name, scene_id, map_id)
	
	-- 创建新场景
	self._mCurScene = scene_cls.new(scene_id, map_id)
	self._sCurSceneName = scene_name
	
	-- 运行新场景
	self:RunScene(self._mCurScene)
	
	-- 
	if OnLoadingOver then OnLoadingOver() end
	self._mCurScene:OnLoadingOver()
	
	FireGlobalEvent("ENTER_SCENE")
	
	self.bSwitching = false
	
	return self._mCurScene
end

function ClsSceneMgr:ShowLoading(OnLoadingOver)
	assert(not self.bIsLoading, "已经在loading中了")
	if self.bIsLoading then return end
	self.bIsLoading = true
	
	if not self._mLoadingPanel then
		local loading_layer = KE_Director:GetLayerMgr():GetLayer(const.LAYER_LOADING)
		self._mLoadingPanel = ui.clsWindow.new(loading_layer,"src/data/uiconfigs/ui_loading/loading_panel.lua")
		self._mLoadingPanel:SetModal(true, false)
	end
	KE_Director:GetLayerMgr():ShowLayer(const.LAYER_LOADING, true)
	
	local iCount = 0
	local MAX_VALUE = 200
	KE_SetInterval(1,function()
		iCount = iCount + math.random(1,10)
		if iCount >= MAX_VALUE then 
			KE_Director:GetLayerMgr():ShowLayer(const.LAYER_LOADING, false)
			self.bIsLoading = false
			
			KE_SetTimeout(1,function() 
				if OnLoadingOver then OnLoadingOver() end 
				self._mCurScene:OnLoadingOver()
			end)
			
			return true 
		end
		
		self._mLoadingPanel:GetCompByName("bar_timer"):setPercent(iCount/MAX_VALUE*100)
	end)
end
