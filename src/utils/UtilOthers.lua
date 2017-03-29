----------------------
-- 辅助库
----------------------
module("utils", package.seeall)

function Second2Frame(iSecond)
	return GAME_CONFIG.FPS * iSecond
end

function Frame2Second(iTotalFrame)
	return iTotalFrame/GAME_CONFIG.FPS
end

function TellMe(Txt, DelayTime)
	ClsUIManager.GetInstance():TellMe(Txt, DelayTime)
end

function TellNotice(sNotice)
	ClsUIManager.GetInstance():TellNotice(sNotice)
end

function TellBarrage(sCont)
	ClsUIManager.GetInstance():TellBarrage(sCont)
end

function AddObj2Map(obj, x, y)
	if KE_TheMap then
		return KE_TheMap:AddObject(obj, x, y)
	end
	return false 
end
