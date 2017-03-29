----------------
-- 排行榜管理器
----------------
clsRankManager = class("clsRankManager", clsCoreObject)
clsRankManager.__is_singleton = true

function clsRankManager:ctor()
	clsCoreObject.ctor(self)
	self.tAllRankList = {
		["竞技场排行榜"] = {},
		["战力排行榜"] = {},
		["等级排行榜"] = {},
	--	["官阶排行榜"] = {},
		["威望排行榜"] = {},
	--	["将领排行榜"] = {},
	--	["消费排行榜"] = {},
	}
	self.tVersionInfo = {}
	self.tMyRankInfo = {}
	
	--测试数据
	for key, RankList in pairs(self.tAllRankList) do
		for i = 1, 1000 do
			RankList[#RankList+1] = {
				Uid = 10000+i,
				RankIdx = i,
				Name = key.."_"..i,
				Level = math.random(1,100),
				Sport = 120-i,
				HeadId = 1020005,
			}
		end
	end
end

function clsRankManager:dtor()

end

function clsRankManager:GetAllRanklist()
	return self.tAllRankList
end

function clsRankManager:IsValidRankKey(sKey)
	return self.tAllRankList[sKey] ~= nil 
end

function clsRankManager:GetRanklist(sKey)
	assert(self:IsValidRankKey(sKey), "获取排行榜失败，无效的键："..sKey)
	return self.tAllRankList[sKey]
end

-- { Uid, sName, TypeId, iShapeId, HeadId, iGrade, iVipLevel, iCareer, iCountryId }
function clsRankManager:UpdateRankList(RankKey, Ver, From, InfoList, MyRank)
	if self.tVersionInfo[RankKey] ~= Ver then
		self.tAllRankList[RankKey] = {}
		self.tMyRankInfo[RankKey] = nil
		assert(From == 1)
	end
	
	self.tVersionInfo[RankKey] = Ver
	self.tMyRankInfo[RankKey] = MyRank
	
	local To = #InfoList
	local idx = 0
	for i = From, To do
		idx = idx + 1
		self.tAllRankList[RankKey][i] = InfoList[idx]
	end
end

function clsRankManager:ReqRankList(RankKey)
	local From = #self.tAllRankList[RankKey]
	local Ver = self.tVersionInfo[RankKey]
	network.SendPro("s_ranklist", nil, RankKey, Ver, From)
end
