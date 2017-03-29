----------------------
-- 游戏辅助库
----------------------
module("utils", package.seeall)

function TellTips(...)
	ClsTipsMgr.GetInstance():ShowTipWnd(...)
end

function PopReward(BonusList)
	if not BonusList or #BonusList<=0 then return end
	local procedure_1 
	procedure_1 = procedure.clsProcedure.new(
			function() 
				local wnd = ClsUIManager.GetInstance():ShowTips("clsRewardPanel", true, function()
					procedure_1:OnEnd()
				end) 
				if wnd then wnd:SetBonusList(BonusList) end
			end, 
			function() 
				ClsUIManager.GetInstance():DestroyWindow("clsRewardPanel") 
			end )
	procedure_1:SetDuration(utils.Second2Frame(3))
	KE_Director:GetProcedureMgr():PushBack(procedure_1)
end

function ReqUseItem(itemId, Amount)
	if Amount == -1 then	--为-1表示使用完所有的数量
		Amount = KE_Director:GetItemMgr():GetItemAmountById(itemId)
	end
	
	if Amount <= 0 then
		utils.TellMe("不存在该物品")
		return 	
	end
	
	network.SendPro("s_use_item", nil, itemId, Amount)
end
