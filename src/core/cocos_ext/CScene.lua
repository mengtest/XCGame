clsScene = class("clsScene", function() return cc.Scene:create() end)

function clsScene:ctor()
	
end

function clsScene:dtor()
	KE_RemoveFromParent(self)
end

KE_ExtendClass(clsScene)
