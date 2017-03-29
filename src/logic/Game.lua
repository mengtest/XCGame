------------------
-- 控制游戏进程
------------------
clsGame = class("clsGame")
clsGame.__is_singleton = true

function clsGame:ctor()
	self:OnInit()
	ClsUpdator.GetInstance():RegisterUpdator(self.FrameUpdate, self, ClsUpdator.ORDER_GAME)
end

function clsGame:dtor()
	ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
	self:OnDestroy()
end

function clsGame:OnInit()
	self._mPhysWorld = ClsPhysicsWorld.GetInstance()			--碰撞检测空间
	self._mRoleMgr = ClsRoleMgr.GetInstance()					--角色管理器
	self._mEffectMgr = ClsEffectMgr.GetInstance()				--特效管理器
	self._mStoryPlayer = ClsStoryPlayer.GetInstance()			--剧情播放器
	self._mFightSystem = fight.ClsFightSystem.GetInstance()		--战斗管理器
	return true
end

function clsGame:OnDestroy()
	self._mPhysWorld = ClsPhysicsWorld.DelInstance()
	self._mStoryPlayer = ClsStoryPlayer.DelInstance()
	self._mFightSystem = fight.ClsFightSystem.DelInstance()
	self._mEffectMgr = ClsEffectMgr.DelInstance()
	self._mRoleMgr = ClsRoleMgr.DelInstance()
end

--@每帧更新
function clsGame:FrameUpdate(deltaTime)
	self._mRoleMgr:FrameUpdate(deltaTime)
end

function clsGame:StartGame()
	-- 创建主角
	local hero = ClsRoleMgr.GetInstance():CreateHero()
	-- 进入休闲场景
	ClsSceneMgr.GetInstance():Turn2Scene("rest_scene")
end

function clsGame:PauseGame()
	
end

function clsGame:ResumeGame()
	
end


function clsGame:_RunTests()
	utils.TellMe("开始游戏")
	utils.TellNotice("进入游戏了")
	utils.TellBarrage("我是一条弹幕")
	--
	local obj_layer = KE_Director:GetLayerMgr():GetLayer(const.LAYER_OBJ)
	--
	local tmpEff = clsEffectSeq.new(-1, nil, obj_layer, 1, function()
		KE_SafeDelete(tmpEff)
	end)
	tmpEff:setPosition(400,290)
	--
	test.arm_async_load(obj_layer, 300, 300)
	--
	test.arm_direct_load(obj_layer)
	--
	test.test_3D(obj_layer)
	--
	clsEffectQuad.new(-1, "", hero, loop_times, function() end)
	--
	local testSeq = clsActorSeq.new(11001)
	KE_SetParent(testSeq, hero)
	testSeq:SetAni("walk")
	--
	local eff = ClsEffectMgr.GetInstance():NewEffectQuad("res/effects/particle/skills/SpookyPeas.plist", hero)
	KE_SetTimeout(GAME_CONFIG.FPS*4, function() KE_SafeDelete(eff) end)
	--
	local emitter = cc.ParticleFire:create()
	KE_SetParent(emitter, KE_Director:GetLayerMgr():GetLayer(const.LAYER_OBJ))
	emitter:setPosition(520,580)
	emitter:setPositionType(cc.POSITION_TYPE_GROUPED)
end
