----------------------
-- 类用法示例 
----------------------
module("test", package.seeall)

local clsTestBase1 = class("clsTestBase1")
function clsTestBase1:ctor() 
	print("构造 clsTestBase1") 
end
function clsTestBase1:dtor() 
	print("析构 clsTestBase1") 
end

local clsTestSon1 = class("clsTestSon1", clsTestBase1)
function clsTestSon1:ctor() 
	clsTestBase1.ctor(self)
	print("构造 clsTestSon1") 
end
function clsTestSon1:dtor() 
	print("析构 clsTestSon1") 
end

local clsTestSon2 = class("clsTestSon2", clsTestBase1)
function clsTestSon2:ctor() 
	clsTestBase1.ctor(self)
	print("构造 clsTestSon2") 
end
function clsTestSon2:dtor() 
	print("析构 clsTestSon2") 
end

local clsTestSonSon1 = class("clsTestSonSon1", clsTestSon2, clsTestSon1)
function clsTestSonSon1:ctor() 
	clsTestSon2.ctor(self)
	clsTestSon1.ctor(self)
	print("构造 clsTestSonSon1") 
end
function clsTestSonSon1:dtor() 
	print("析构 clsTestSonSon1") 
end

test_class = function()
	print("----------------")
	local m1 = clsTestBase1.new()
	print("----------------")
	local m2 = clsTestSon1.new()
	print("----------------")
	local m3 = clsTestSon2.new()
	print("----------------")
	local m4 = clsTestSonSon1.new()
	print("----------------")
	KE_SafeDelete(m4)  m4 = nil
end

do return end


local clsScene = class("clsScene", function() return cc.Scene:create() end, clsGameObject)
function clsScene:ctor()
	clsGameObject.ctor(self)
	print("构造函数 clsScene")
end


local clsSprite = class("clsSprite", function() return cc.Sprite:create() end, clsCoreObject, clsGameObject)

function clsSprite:ctor(sTex)
	clsCoreObject.ctor(self)
	clsGameObject.ctor(self)
	
	print("  构造函数 clsSprite")
	self.sTex = sTex
	self:setTexture(sTex)
end

function clsSprite:dtor()
	print("析构函数 clsSprite", self.sTex)
	KE_RemoveFromParent(self)
	KE_RemoveFromParent(self)
	KE_RemoveFromParent(self)
end

local clsSubSprite = class("clsSubSprite", clsSprite)

function clsSubSprite:ctor(sTex, parent)
	clsSprite.ctor(self, sTex)
	print("  构造函数 clsSubSprite")
	KE_SetParent(self, parent)
end

function clsSubSprite:dtor()
	print("析构函数 clsSubSprite", self.sTex)
	KE_RemoveFromParent(self)
	KE_RemoveFromParent(self)
end

local clsLeafSprite = class("clsLeafSprite", clsCoreObject, clsSprite, clsSubSprite)

function clsLeafSprite:ctor(sTex, parent)
	clsCoreObject.ctor(self)
	clsSprite.ctor(self, sTex)
	clsSubSprite.ctor(self, sTex, parent)
	print("    构造函数 clsLeafSprite")
end

function clsLeafSprite:dtor()
	print("析构函数 clsLeafSprite", self.sTex)
end


----华丽丽的分割线-----------------------------

function countTable(tbl)
	if not tbl then return "nil" end
	local cnt = 0
	for k, v in pairs(tbl) do
		cnt = cnt + 1
	end
	return cnt
end

aaaaaaaaa = class("aaaaaaaaa")
function aaaaaaaaa:ctor()

end

function aaaaaaaaa:dtor()

end

function aaaaaaaaa.mimi()

end

function test_class()
	local weaktbl = new_weak_table("v")
	
	local theScene = clsScene.new()
	cc.Director:getInstance():runWithScene(theScene)
--	weaktbl[theScene] = true
	table.insert(weaktbl, theScene)
	
	local theSprite = clsSprite.new("res/uiface/panels/wnd1.png")
	KE_SetParent(theSprite, theScene)
	theSprite:setPosition(400, 300)
--	weaktbl[theSprite] = true
	table.insert(weaktbl, theSprite)
	
	local childSprite = clsSprite.new("ui/uitest/r1.png")
	KE_SetParent(childSprite, theSprite)
	childSprite:setPosition(100,50)
--	weaktbl[childSprite] = true
	table.insert(weaktbl, childSprite)
	
	local sprSub = clsSubSprite.new("ui/uitest/f1.png", childSprite)
	KE_SetParent(sprSub, childSprite)
--	weaktbl[sprSub] = true
	table.insert(weaktbl, sprSub)
	
	local leafSpr = clsLeafSprite.new("ui/uitest/btn_add.png", sprSub)
	KE_SetParent(leafSpr, sprSub)
	leafSpr:setPosition(200, 90)
--	weaktbl[leafSpr] = true
	table.insert(weaktbl, leafSpr)
	
	ttaaa = aaaaaaaaa.new()
	table.insert(weaktbl, ttaaa.mimi)
	
	local function deleteTheSprite()
		KE_SafeDelete(theSprite)
		KE_SafeDelete(theSprite)
		KE_SafeDelete(theSprite)
		theSprite=nil 
		
		print("before gc", countTable(weaktbl))
		KE_GC()
		print("after gc", countTable(weaktbl))
		theScene.ref0000 = leafSpr
	end
	KE_SetTimeout(60*2, deleteTheSprite)
	
	local obj1 = clsGameObject.new()
	theScene:addChild(obj1)
	
	KE_SetTimeout(60*3, function()
		print("-------销毁obj1")
		obj1:removeFromParent(true)
		
		print("before gc", countTable(weaktbl))
		KE_GC()
		print("after gc", countTable(weaktbl))
		
		theScene.ref0000 = nil
		print("相等吗", ttaaa.mimi, aaaaaaaaa.mimi, ttaaa.mimi == aaaaaaaaa.mimi)
		
		print("before gc", countTable(weaktbl))
		KE_GC()
		print("after gc", countTable(weaktbl))
		
		ttaaa = nil
		print("before gc", countTable(weaktbl))
		KE_GC()
		print("after gc", countTable(weaktbl))
		
		aaaaaaaaa.mimi = nil
		print("before gc", countTable(weaktbl))
		KE_GC()
		print("after gc", countTable(weaktbl))
	end)
end
