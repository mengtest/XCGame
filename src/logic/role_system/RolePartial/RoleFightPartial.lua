-------------------------
-- 战斗相关
-------------------------
local DRIBBLE_FRAME = GAME_CONFIG.FPS * 2

function clsRole:RecoverHP()
	self.mRoleData:SetiCurHP(self.mRoleData:GetiMaxHP())
end

function clsRole:AddHP(iHp)
	self.mRoleData:SetiCurHP( self.mRoleData:GetiCurHP() + iHp )
end

--连击+1
function clsRole:IncDribble()
	self.iDribble = self.iDribble + 1
	self.iDribbleFlag = DRIBBLE_FRAME
end

-- 连击清零
function clsRole:ClearDribble()
	self.iDribble = 0
	self.iDribbleFlag = 0
end

--碰撞
--@override
function clsRole:OnCollision(oTarget)
	if self:IsDead() then return end
	
	local DamageInfo = oTarget:GetDamageInfo()
	if not DamageInfo then return end
	
	self:ClearRoadPath()
	
	if DamageInfo.tResults and DamageInfo.tResults[self] then
		if fight.ClsFightSystem.GetInstance():IsAffectEnable() then
			local AffectFunc = DamageInfo.AffectFunc
			local FuncName = AffectFunc and AffectFunc.funcName
			if FuncName == "OnEcForce" then
				self:OnEcForce(oTarget, AffectFunc.param)
			elseif FuncName == "OnEcDevour" then
				self:OnEcDevour(oTarget, AffectFunc.param)
			end
		end
	else
		self:OnHit(oTarget, DamageInfo)
		oTarget:OnAttack(self, DamageInfo)
	end
end

-- 攻击
--@override
function clsRole:OnAttack(Victim, DamageInfo)
	if self:GetDamageInfo() == false then return end
	assert(DamageInfo==self:GetDamageInfo(), string.format("not equal: %s , %s",DamageInfo,self:GetDamageInfo()))
	
	if DamageInfo.iIsSingleAtk == 1 then
		self:SetDamageInfo(false)
	else
		DamageInfo.tResults = DamageInfo.tResults or new_weak_table("k")
		DamageInfo.tResults[Victim] = true
	end
	
	self:IncDribble()
end

-- 受击
--@override
function clsRole:OnHit(Attacker, DamageInfo)
	------ 计算伤害 ------
	local iHurtValue = -112 	--DamageInfo.iDamagePower
	local newCurHP = self.mRoleData:GetiCurHP() + iHurtValue
	self.mRoleData:SetiCurHP(newCurHP)
	
	-- 死亡判断
	if newCurHP <= 0 then
		self:Turn2ActState(ROLE_STATE.ST_DIE)
		return 
	end
	
	------ 受击表现 ------
	
	-- 受击动作
	self:Turn2ActState(ROLE_STATE.ST_HIT)
	
	-- 浮空 击退 冰冻等等表现
	if fight.ClsFightSystem.GetInstance():IsAffectEnable() then
		local AffectFunc = DamageInfo.AffectFunc
		if AffectFunc then
			self[AffectFunc.funcName](self, Attacker, AffectFunc.param)
		end
	end
	
	--播放声音，溅血特效，掉血飘字，连击数展示
end

-- 1. 冲击力
function clsRole:OnEcImpact(Attacker, param)
	-- 受竖直方向作用力
	if param.iCZspeed > 0 then
		self:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = param.iCZspeed,
		})
	elseif self:IsInSky() and Attacker:IsInSky() then
		self:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = 18,
		})
	end
	
	-- 受水平方向作用力
	if param.iSPframe ~= 0 then
		local factor = self:GetActState() == ROLE_STATE.ST_SKILL and 0.4 or 1  --技能状态下效果衰减
		self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVLINE, {
			movDir = Attacker:GetDirection(),
			movFrame = factor * param.iSPframe,
			movSpeed = factor * param.iSPspeed,
		})
	end
end

-- 2. 持续力
function clsRole:OnEcForce(Attacker, param)
	-- 受竖直方向作用力
	if param.iCZspeed ~= 0 and (self:GetActState()==ROLE_STATE.ST_HIT or self:GetActState()==ROLE_STATE.ST_FLIGHT) then
		self:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = param.iCZspeed,
		})
	end
	
	-- 受水平方向作用力
	if param.iSPframe ~= 0 then
		local factor = self:GetActState() == ROLE_STATE.ST_SKILL and 0.4 or 1  --技能状态下效果衰减
		self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVLINE, {
			movDir = Attacker:GetDirection(),
			movFrame = 1,
			movSpeed = factor * Attacker:GetCurMoveSpeed(),
		})
	end
end

-- 3. 拖拽力
function clsRole:OnEcDrag(Attacker, param)
	self:Turn2ActState(ROLE_STATE.ST_IDLE)
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	
	local theOwner = Attacker:GetOwner()
	if not theOwner then return end
	
	local distance = param.iDistance 
	local dir = theOwner:GetDirection()
	local x, y = theOwner:getPosition()
	self:setPosition(x+distance*math.cos(dir), y+distance*math.sin(dir))
end

-- 4. 吞噬力
function clsRole:OnEcDevour(Attacker, param)
	local iDevourH = param.iDevourH
	-- 受竖直方向作用力
	if iDevourH > 0 and self:GetPositionH() < iDevourH then
		self:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = 3,
		})
	end
	
	-- 受水平方向作用力
	local xAttacker, yAttacker = Attacker:getPosition()
	local x, y = self:getPosition()
	local dX, dY = x-xAttacker, y-yAttacker
	local dir = math.Vector2Radian(dX,dY)
	local dis = math.sqrt((dX*dX)+(dY*dY)) * 0.95
	self:setPosition(xAttacker+dis*math.cos(dir), yAttacker+dis*math.sin(dir))
end

-- 5. 冻结力
function clsRole:OnEcFreeze(Attacker, param)
	-- 冻结移动
	if param.iFreezeMovTime > 0 then
		self:Turn2SkyMovState(ROLE_STATE.ST_SKYMOVFREEZE, {iFreeseTime=param.iFreezeMovTime})
		self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVFREEZE, {iFreeseTime=param.iFreezeMovTime})
	end
	
	-- 冻结动作
	if param.iFreezeActTime > 0 then
		self:Turn2ActState(ROLE_STATE.ST_FREEZE, {iFreeseTime=param.iFreezeActTime})
	end
end


-------------------------
-- 测试方法
-------------------------
--测试击退
function clsRole:TestHitBack()
	self:Turn2ActState(ROLE_STATE.ST_HIT)
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVLINE, {
		["movDir"] = (self:GetDirection()+math.pi)%(math.pi*2),
		["movFrame"] = 5,
		["movSpeed"] = 15,
	})
end

--测试浮空
function clsRole:TestHitFloat()
	self:Turn2ActState(ROLE_STATE.ST_FLIGHT)
	self:Turn2SkyMovState(ROLE_STATE.ST_SKYMOVLINE, {["jmpSpeed"] = const.FLIGHT_SPEED})
end

--测试冻结
function clsRole:TestFreeze()
	self:Turn2SkyMovState(ROLE_STATE.ST_SKYMOVFREEZE, {iFreeseTime=GAME_CONFIG.FPS})
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVFREEZE, {iFreeseTime=GAME_CONFIG.FPS})
	self:Turn2ActState(ROLE_STATE.ST_FREEZE, {iFreeseTime=GAME_CONFIG.FPS})
end

--测试受击
function clsRole:TestHit()
	self:Turn2ActState(ROLE_STATE.ST_HIT)
end

--测试死亡
function clsRole:TestDie()
	self:Turn2ActState(ROLE_STATE.ST_DIE)
end

--测试复活
function clsRole:TestRevive()
	self:Turn2ActState(ROLE_STATE.ST_REVIVE)
end
