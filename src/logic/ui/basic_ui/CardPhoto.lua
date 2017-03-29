-----------------
-- 卡牌
-----------------
module("ui", package.seeall)

local ORDER_SPRICON = 1
local ORDER_LABELNAME = 2
local ORDER_LABELCOMBATFORCE = 2
local ORDER_LABEL_GRADE = 2
local ORDER_STAR = 2
local ORDER_SPRCAREER = 2
local ORDER_MARKSPR = 3

local FRAME_STYPE = {
	[0] = "res/card/frames/card_frame_empty.png",
	[1] = "res/card/frames/card_frame_gray.png",
	[2] = "res/card/frames/card_frame_green.png",
	[3] = "res/card/frames/card_frame_blue.png",
	[4] = "res/card/frames/card_frame_purple.png",
	[5] = "res/card/frames/card_frame_gold.png",
}
local CAREER_IMG_DARK = {
	"res/icons/career/career_1.png",
	"res/icons/career/career_2.png",
	"res/icons/career/career_3.png",
	"res/icons/career/career_4.png",
	"res/icons/career/career_5.png",
}
local CAREER_IMG_LIGHT = {
	"res/icons/career/career_1_1.png",
	"res/icons/career/career_2_1.png",
	"res/icons/career/career_3_1.png",
	"res/icons/career/career_4_1.png",
	"res/icons/career/career_5_1.png",
}

local ICON_WID,ICON_HEI = 130, 195
local HALF_ICON_WID, HALF_ICON_HEI = 65, 97


clsCardPhoto = class("clsCardPhoto", clsWindow)

function clsCardPhoto:ctor(parent)
	clsWindow.ctor(self, parent)
	--
	self.iNpcId = nil
	self._TypeId = nil
	
	self._Name = nil
	self._iCombatForce = nil
	--
	self.mSprIcon = nil
	self.mSprCareer = nil
	self.mLabelName = nil
	self.mLabelCombatForce = nil
	--
	self:loadTexture("res/card/frames/card_frame_red.png")
end

function clsCardPhoto:dtor()
	
end

function clsCardPhoto:_SetPhoto(imgPath)
	KE_SafeDelete(self.mSprIcon)
	self.mSprIcon = nil
	if not imgPath or imgPath=="" then return end
	-- self.mSprIcon = cc.Sprite:create(imgPath, cc.rect(15,15,120,120))
	self.mSprIcon = cc.Sprite:create(imgPath)
	if not self.mSprIcon then 
		print("_SetPhoto Failed: ", imgPath)
		return 
	end
	KE_SetParent(self.mSprIcon, self, ORDER_SPRICON)
	self.mSprIcon:setPosition(HALF_ICON_WID, 100)
end

function clsCardPhoto:_SetCareer(iCareer)
	if self._iCareer == iCareer then return end
	self._iCareer = iCareer
	KE_SafeDelete(self.mSprCareer)
	self.mSprCareer = nil
	if not iCareer then return end
	assert(CAREER_IMG_LIGHT[iCareer], "不存在该职业编号："..iCareer)
	self.mSprCareer = cc.Sprite:create(CAREER_IMG_LIGHT[iCareer])
	KE_SetParent(self.mSprCareer, self, ORDER_SPRCAREER)
	self.mSprCareer:setScale(36/80)
	self.mSprCareer:setPosition(27, 175)
end

function clsCardPhoto:_SetName(nameStr)
	if self._Name == nameStr then return end
	self._Name = nameStr
	if not self.mLabelName then
		local fontcfg = const.DEF_FONT_CFG()
		fontcfg.fontSize = 16
		self.mLabelName = cc.Label:createWithTTF(fontcfg, "0") 
		KE_SetParent(self.mLabelName, self, ORDER_LABELNAME)
		self.mLabelName:setPosition(HALF_ICON_WID,16)
	end
	self.mLabelName:setString(nameStr or "")
end

function clsCardPhoto:_SetGrade(iGrade)
	if self._iGrade == iGrade then return end
	self._iGrade = iGrade
	if not self.mLabelGrade then
		local fontcfg = const.DEF_FONT_CFG()
		fontcfg.fontSize = 16
		self.mLabelGrade = cc.Label:createWithTTF(fontcfg, "0") 
		KE_SetParent(self.mLabelGrade, self, ORDER_LABEL_GRADE)
		self.mLabelGrade:setPosition(15,145)
		self.mLabelGrade:setAnchorPoint(cc.p(0,0.5))
		self.mLabelGrade:setAlignment(cc.TEXT_ALIGNMENT_LEFT)
	end
	self.mLabelGrade:setString(iGrade and string.format("Lv.%d",iGrade) or "")
end

function clsCardPhoto:_SetCombatForce(iCombatForce)
	if self._iCombatForce == iCombatForce then return end
	self._iCombatForce = iCombatForce
	if not self.mLabelCombatForce then
		local fontcfg = const.DEF_FONT_CFG()
		fontcfg.fontSize = 14
		self.mLabelCombatForce = cc.Label:createWithTTF(fontcfg, "") 
		KE_SetParent(self.mLabelCombatForce, self, ORDER_LABELCOMBATFORCE)
		self.mLabelCombatForce:setPosition(45,176)
		self.mLabelCombatForce:setAnchorPoint(cc.p(0,0.5))
		self.mLabelCombatForce:setAlignment(cc.TEXT_ALIGNMENT_LEFT)
	end
	self.mLabelCombatForce:setString(iCombatForce or "")
end

function clsCardPhoto:_SetStarLv(iStarLv)
	if self._iStarLv == iStarLv then return end
	self._iStarLv = iStarLv
	iStarLv = iStarLv or 0
	self._StarSprList = self._StarSprList or {}
	for i=1, const.MAX_CARD_STARLV do
		if i <= iStarLv then
			if not self._StarSprList[i] then
				self._StarSprList[i] = cc.Sprite:create("res/icons/star_1.png")
				KE_SetParent(self._StarSprList[i], self, ORDER_STAR)
			end
			self._StarSprList[i]:setPosition(HALF_ICON_WID+18*(i-(1+iStarLv)/2), 35-math.abs((i-(1+iStarLv)/2)))
		else
			if self._StarSprList[i] then
				KE_SafeDelete(self._StarSprList[i])
				self._StarSprList[i] = nil 
			end
		end
	end
end

---------------------
-- 对外接口
---------------------

function clsCardPhoto:SetTypeId(iTypeId)
	if self._TypeId == iTypeId then return end
	self._TypeId = iTypeId
	
	if iTypeId then
		local CardInfo = setting.T_card_cfg[iTypeId]
		assert(CardInfo, "未配置的卡片："..iTypeId)
		local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(self.iNpcId)
		if self.iNpcId and RoleData then
			assert(iTypeId==RoleData:GetTypeId(), "卡牌TypeId和对应的卡片数据不一致")
		end
		
		--
		local imgPath = string.format("res/card/photos/c%d.png",iTypeId)
		self:_SetPhoto(imgPath)
		--
		local CountryId = RoleData and RoleData:GetiCountryId()
		local CountryData = KE_Director:GetCountryMgr():GetCountry(CountryId)
		local CountryName = CountryData and CountryData:GetsName() or "未知"
		local CardName = CardInfo.sName
		self:_SetName(string.format("%s·%s", CountryName, CardName))
		--
		self:_SetCareer(CardInfo.iCareer)
		--
		self:_SetCombatForce(10023)
		self:_SetStarLv(math.random(1,5))
		self:_SetGrade(math.random(1,255))
	else
		self:_SetPhoto(nil)
		self:_SetName(nil)
		self:_SetCareer(nil)
		self:_SetCombatForce(nil)
		self:_SetStarLv(nil)
		self:_SetGrade(nil)
	end
end

function clsCardPhoto:SetNpcId(iNpcId)
	self.iNpcId = iNpcId
	
	if iNpcId then
		local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(self.iNpcId)
		local TypeId = RoleData and RoleData:GetTypeId()
		assert(TypeId, "卡牌数据错误："..iNpcId)
		self:SetTypeId(TypeId)
	else
		self:SetTypeId(nil)
	end
end

function clsCardPhoto:SetMarked(bMarked)
	if self.bMarked == bMarked then return end
	self.bMarked = bMarked
	
	if bMarked then
		self.mSprMark = cc.Sprite:create("res/icons/gougou.png")
		KE_SetParent(self.mSprMark, self, ORDER_MARKSPR)
		self.mSprMark:setPosition(HALF_ICON_WID,HALF_ICON_HEI)
	else
		KE_SafeDelete(self.mSprMark)
		self.mSprMark = nil
	end
end

function clsCardPhoto:SetGray(bGray)
	if bGray then
		self.mSprIcon:setColor(cc.c3b(30,59,12))
		self:setColor(cc.c3b(30,59,12))
	else
		self.mSprIcon:setColor(cc.c3b(255,255,255))
		self:setColor(cc.c3b(255,255,255))
	end
end

function clsCardPhoto:IsMarded()
	return self.bMarked
end

function clsCardPhoto:GetNpcId() 
	return self.iNpcId 
end

function clsCardPhoto:GetTypeId()
	return self._TypeId
end
