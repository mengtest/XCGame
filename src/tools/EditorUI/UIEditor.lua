-----------------
-- UI编辑器
-----------------
module("editorui", package.seeall)

ClsUIEditor = class("ClsUIEditor")

function ClsUIEditor:ctor()
	self.mCurScene = clsGameScene.new()
	KE_Director:GetSceneMgr():RunScene(self.mCurScene)
	
	self.mUIEditPanel = clsUIEditPanel.new()
end

function ClsUIEditor:dtor()
	if self.mUIEditPanel then
		KE_SafeDelete(self.mUIEditPanel)
		self.mUIEditPanel = nil 
	end
end

function ClsUIEditor:GetUIEditPanel()
	return self.mUIEditPanel
end
