----------------
-- 总管理中心
----------------
ClsDirector = class("ClsDirector")
ClsDirector.__is_singleton = true

function ClsDirector:ctor()
	KE_Director = self
	--
	self.mResMgr = ClsResMgr.GetInstance()					--资源管理器
	self.mAudioMgr = ClsAudioMgr.GetInstance()				--音频管理器
	self.mCacheMgr = cache.ClsCacheMgr.GetInstance()		--本地缓存管理器
	self.mProcedureMgr = procedure.ClsProcedureMgr.GetInstance()	--串行执行管理器
	--
	self.mLayerMgr = ClsLayerMgr.GetInstance()				--层管理器
	self.mSceneMgr = ClsSceneMgr.GetInstance()				--场景管理器
	self.mUIMgr = ClsUIManager.GetInstance()				--UI管理器
	self.mWeatherMgr = ClsWeatherMgr.GetInstance()			--天气系统
	self.mBTFactory = ai.ClsBTFactory.GetInstance()			--AI Factory
	self.mPathFinder = ClsPathFinder.GetInstance()			--寻路器
end

function ClsDirector:dtor()
	KE_Director = nil
	assert(false)
end

function ClsDirector:InitGameStateMachine()
	self.mStateMachine = ClsStateMachine.GetInstance()	--游戏状态机
	return self.mStateMachine
end

-- 初始化数据
function ClsDirector:InitUserDatas()
	self.mGuideMgr = guide.ClsGuideMgr.GetInstance()			--新手指引
	self.mRoleDataMgr = ClsRoleDataMgr.GetInstance()			--角色属性数据
	self.mSkillDataMgr = ClsSkillDataMgr.GetInstance()			--技能数据
	self.mTimeMgr = ClsTimeManager.GetInstance()				--游戏逻辑相关的一些计时，如免费抽奖倒计时等
	--
	self.mEquipMgr = clsEquipManager.GetInstance()				--装备
	self.mEmailMgr = clsEmailManager.GetInstance()				--邮件
	self.mFriendMgr = clsFriendManager.GetInstance()			--好友
	self.mHorseMgr = clsHorseManager.GetInstance()				--坐骑
	self.mItemMgr = clsItemManager.GetInstance()				--物品
	self.mStoneMgr = clsStoneManager.GetInstance()				--宝石
	--
	self.mStageMgr = clsStageManager.GetInstance()				--关卡
	self.mCountryMgr = clsCountryManager.GetInstance()			--国家
	self.mCityMgr = clsCityManager.GetInstance()				--城堡
	self.mWarMgr = clsWarManager.GetInstance()					--
	self.mBattleMgr = clsBattleManager.GetInstance()			--
	self.mTroopMgr = clsTroopManager.GetInstance()				--
	self.mEmbattleMgr = ClsEmbattleManager.GetInstance()		--
	--
	self.mActivityMgr = clsActivityManager.GetInstance()		--活动
	self.mShopMgr = clsShopManager.GetInstance()				--商店
	self.mVipMgr = clsVipManager.GetInstance()					--VIP 
	self.mChatMgr = clsChatManager.GetInstance()				--聊天
	self.mSignInMgr = clsSignInManager.GetInstance()			--签到
	self.mRankMgr = clsRankManager.GetInstance()				--排行榜
	self.mExchangeMgr = clsExchangeManager.GetInstance()		--
	self.mRecruitMgr = clsCardManager.GetInstance()				--招揽
end

-- 清理数据
function ClsDirector:ClearUserDatas()
	self.mGuideMgr = guide.ClsGuideMgr.DelInstance()			--新手指引
	self.mRoleDataMgr = ClsRoleDataMgr.DelInstance()			--角色属性数据
	self.mSkillDataMgr = ClsSkillDataMgr.DelInstance()			--技能数据
	self.mTimeMgr = ClsTimeManager.DelInstance()				--游戏逻辑相关的一些计时，如免费抽奖倒计时等
	--
	self.mEquipMgr = clsEquipManager.DelInstance()				--装备
	self.mEmailMgr = clsEmailManager.DelInstance()				--邮件
	self.mFriendMgr = clsFriendManager.DelInstance()			--好友
	self.mHorseMgr = clsHorseManager.DelInstance()				--坐骑
	self.mItemMgr = clsItemManager.DelInstance()				--物品
	self.mStoneMgr = clsStoneManager.DelInstance()				--宝石
	--
	self.mStageMgr = clsStageManager.DelInstance()				--关卡
	self.mCountryMgr = clsCountryManager.DelInstance()			--国家
	self.mCityMgr = clsCityManager.DelInstance()				--城堡
	self.mWarMgr = clsWarManager.DelInstance()					--
	self.mBattleMgr = clsBattleManager.DelInstance()			--
	self.mTroopMgr = clsTroopManager.DelInstance()				--
	self.mEmbattleMgr = ClsEmbattleManager.DelInstance()		--
	--
	self.mActivityMgr = clsActivityManager.DelInstance()		--活动
	self.mShopMgr = clsShopManager.DelInstance()				--商店
	self.mVipMgr = clsVipManager.DelInstance()					--VIP 
	self.mChatMgr = clsChatManager.DelInstance()				--聊天
	self.mSignInMgr = clsSignInManager.DelInstance()			--签到
	self.mRankMgr = clsRankManager.DelInstance()				--排行榜
	self.mExchangeMgr = clsExchangeManager.DelInstance()		--
	self.mRecruitMgr = clsCardManager.DelInstance()				--招揽
end

-- 获取数据
function ClsDirector:GetLayerMgr() return self.mLayerMgr end
function ClsDirector:GetSceneMgr() return self.mSceneMgr end
function ClsDirector:GetUIMgr() return self.mUIMgr end
function ClsDirector:GetPathFinder() return self.mPathFinder end
function ClsDirector:GetStateMachine() return self.mStateMachine end
function ClsDirector:GetResMgr() return self.mResMgr end
function ClsDirector:GetBTFactory() return self.mBTFactory end
function ClsDirector:GetAudioMgr() return self.mAudioMgr end
function ClsDirector:GetCacheMgr() return self.mCacheMgr end
function ClsDirector:GetProcedureMgr() return self.mProcedureMgr end
function ClsDirector:GetGuideMgr() return self.mGuideMgr end
function ClsDirector:GetRoleDataMgr() return self.mRoleDataMgr end
function ClsDirector:GetSkillDataMgr() return self.mSkillDataMgr end
function ClsDirector:GetActivityMgr() return self.mActivityMgr end
function ClsDirector:GetEmailMgr() return self.mEmailMgr end
function ClsDirector:GetEquipMgr() return self.mEquipMgr end
function ClsDirector:GetFactionMgr() return self.mFactionMgr end
function ClsDirector:GetFriendMgr() return self.mFriendMgr end
function ClsDirector:GetHorseMgr() return self.mHorseMgr end
function ClsDirector:GetItemMgr() return self.mItemMgr end
function ClsDirector:GetShopMgr() return self.mShopMgr end
function ClsDirector:GetStageMgr() return self.mStageMgr end
function ClsDirector:GetVipMgr() return self.mVipMgr end
function ClsDirector:GetCountryMgr() return self.mCountryMgr end
function ClsDirector:GetCityMgr() return self.mCityMgr end
function ClsDirector:GetChatMgr() return self.mChatMgr end
function ClsDirector:GetSignInMgr() return self.mSignInMgr end
function ClsDirector:GetRankMgr() return self.mRankMgr end 
function ClsDirector:GetTroopMgr() return self.mTroopMgr end
function ClsDirector:GetEmbattleMgr() return self.mEmbattleMgr end
function ClsDirector:GetExchangeMgr() return self.mExchangeMgr end 
function ClsDirector:GetRecruitMgr() return self.mRecruitMgr end 
function ClsDirector:GetTimeMgr() return self.mTimeMgr end 
function ClsDirector:GetWeatherMgr() return self.mWeatherMgr end

-----------------------------分割线---------------------------------------

function ClsDirector:GetNotificationNode()
	local noti_node = cc.Director:getInstance():getNotificationNode()
	if not noti_node then
		noti_node = cc.Node:create()
		cc.Director:getInstance():setNotificationNode(noti_node)
--		noti_node:registerScriptHandler(function(state) if state=="cleanup" then self.mUIMgr:DestoryUILayer() end end)
	end
	assert(cc.Director:getInstance():getNotificationNode(), "noti_node创建失败")
	return noti_node
end

function ClsDirector:BindCameraOn(Obj)
	if KE_TheMap then KE_TheMap:BindCameraOn(Obj) end
end

function ClsDirector:GetLayer(iLayerId)
	return self.mLayerMgr:GetLayer(iLayerId)
end

function ClsDirector:GetHero()
	return ClsRoleMgr.GetInstance():GetHero()
end

-- 修正我
function ClsDirector:GetHeroId()
	return self.mRoleDataMgr:GetHeroId() or 0
end

function ClsDirector:GetHeroName()
	local HeroData = self:GetHeroData()
	return HeroData and HeroData:GetsName()
end

function ClsDirector:GetHeroData()
	return self.mRoleDataMgr:GetHeroData()
end
