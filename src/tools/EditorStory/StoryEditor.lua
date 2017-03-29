-----------------
-- 剧情编辑器
-----------------
module("editorstory", package.seeall)

COMMON_ATTR = {
	{ PropName = "Id", 			Desc = "ID", 			},
	{ PropName = "cmdName", 	Desc = "命令", 		bEnable = false,	},
	{ PropName = "evtname", 	Desc = "触发点", 	InputMode = cc.EDITBOX_INPUT_MODE_DECIMAL },
}

ClsStoryEditor = class("ClsStoryEditor")

function ClsStoryEditor:ctor(parent)
	local theDirector = ClsDirector:GetInstance()	--初始化ClsDirector
	theDirector:InitUserDatas()
	ClsSceneMgr.GetInstance():Turn2Scene("story_edit_scene")
end

function ClsStoryEditor:dtor()
	
end
