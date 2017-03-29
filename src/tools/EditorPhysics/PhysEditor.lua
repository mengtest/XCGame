-----------------
-- UI编辑器
-----------------
module("editorphys", package.seeall)

ClsPhysEditor = class("ClsPhysEditor")

function ClsPhysEditor:ctor()
	self.mCurScene = clsGameScene.new()
	KE_Director:GetSceneMgr():RunScene(self.mCurScene)
	
	self.mPhysEditPanel = clsPhysEditPanel.new()
end

function ClsPhysEditor:dtor()
	if self.mPhysEditPanel then
		KE_SafeDelete(self.mPhysEditPanel)
		self.mPhysEditPanel = nil 
	end
end

function ClsPhysEditor:GetPhysEditPanel()
	return self.mPhysEditPanel
end
