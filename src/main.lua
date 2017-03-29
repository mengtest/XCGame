--[[
------------------------------------------------------------------

                            _ooOoo_  
                           o8888888o  
                           88" . "88  
                           (| -_- |)  
                            O\ = /O  
                        ____/`---'\____  
                      .   ' \\| |// `.  
                       / \\||| : |||// \  
                     / _||||| -:- |||||- \  
                       | | \\\ - /// | |  
                     | \_| ''\---/'' | |  
                      \ .-\__ `-` ___/-. /  
                   ___`. .' /--.--\ `. . __  
                ."" '< `.___\_<|>_/___.' >'"".  
               | | : `- \`.;`\ _ /`;.`/ - ` : | |  
                 \ \ `-. \_ __\ /__ _/ .-` / /  
         ======`-.____`-.___\_____/___.-`____.-'======  
                            `=---='  
                               
                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   佛祖保佑 永无BUG 永不修改
                   
------------------------------------------------------------------
]]--

collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)

math.randomseed(os.time()) 
math.random() 
math.random() 
math.random()

--------------------------------分割线----------------------------------

-- 设置资源搜索路径
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")

--------------------------------分割线----------------------------------

local _origin_print = print 
print = function(...) end

require "src/config"
require "src/cocos/init"
require "src/anysdkConst"
require "src/app/init"

if device.platform == "windows" then 
	print = _origin_print
end

cc.FileUtils:getInstance():addSearchPath(device.writablePath..LOCAL_DIR)

local ModFileList = {
	---------------------------------------------
	"src/common/init",			-- 通用库
	"src/base/init",			-- 基础库
	---------------------------------------------
	"src/ptogen",				-- 协议自动生成
	---------------------------------------------
	"src/globals/init",			-- 全局与常量
	"src/utils/init",			-- 辅助接口
	---------------------------------------------
	"src/net/init",				-- 网络库
	"src/core/init",			-- 核心库
	---------------------------------------------
	"src/logic/init",			-- 游戏逻辑
	"src/minigame/init",		-- 小游戏逻辑
	---------------------------------------------
	"src/server/init",			-- 虚拟服务器
	---------------------------------------------
	"src/tools/init",			-- 工具集
	"src/test/init",			-- 测试模块
	---------------------------------------------
}

--------------------------------分割线----------------------------------

-- 
local function Run()
	local theDirector = ClsDirector:GetInstance()	--初始化ClsDirector
	
	if KE_APP_MODAL == 1 then	   
	--游戏
		local gameStateMachine = theDirector:InitGameStateMachine()
		gameStateMachine:StartUp()
		
	elseif KE_APP_MODAL == 2 then  
	--特效编辑器
		local theScene = cc.Scene:create()
		ClsSceneMgr.GetInstance():RunScene(theScene)
		
	elseif KE_APP_MODAL == 3 then  
	--UI编辑器
		editorui.ClsUIEditor.GetInstance()
		
	elseif KE_APP_MODAL == 4 then  
	--场景编辑器
		
	elseif KE_APP_MODAL == 5 then  
	--剧情编辑器
		editorstory.ClsStoryEditor.GetInstance()
		
	elseif KE_APP_MODAL == 6 then  
	--AI编辑器
		
	elseif KE_APP_MODAL == 7 then  
	--技能编辑器
		
	elseif KE_APP_MODAL == 8 then  
	--模型编辑器
		
	elseif KE_APP_MODAL == 9 then
	--物理编辑器
		editorphys.ClsPhysEditor.GetInstance()
	end
	
--	test.test_class()
end

local function main()
	--@每帧更新
	local InstTimerMgr = ClsTimerMgr.GetInstance()
	local InstUpdator = ClsUpdator.GetInstance()
	local function UpdateEveryFrame(deltaTime)
		InstTimerMgr:FrameUpdate(deltaTime)
		InstUpdator:FrameUpdate(deltaTime)
	end

	-- 启动全局更新函数
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(UpdateEveryFrame, 0, false)
	-- 启动游戏
	KE_SetTimeout(1, Run)
end

-- 资源的解析和加载
local function StartUp()
	-- 启动APP
	ClsApp.GetInstance()
	
	--创建预加载场景（用于显示加载进度）
	local theScene = cc.Scene:create()
	cc.Director:getInstance():runWithScene(theScene)
	local theSprite = cc.Sprite:create("res/HelloWorld.png")
	theScene:addChild(theSprite)
	theSprite:setPosition(GAME_CONFIG.DESIGN_W/2,GAME_CONFIG.DESIGN_H/2)
	local theProgBar = ccui.LoadingBar:create("res/uiface/progress/preloadbar.png", 0)
	theProgBar:setDirection(ccui.LoadingBarDirection.LEFT)
	theScene:addChild(theProgBar)
	theProgBar:setPosition(GAME_CONFIG.DESIGN_W/2,40)
	local fontcfg = { fontFilePath = "fonts/FZY4JW.TTF", fontSize = 24, glyphs = cc.GLYPHCOLLECTION_DYNAMIC, customGlyphs = nil, distanceFieldEnabled = false, outlineSize = 0, }
	local theLabel = cc.Label:createWithTTF(fontcfg, "资源加载中（0%%）... ...")
	theScene:addChild(theLabel)
	theLabel:setPosition(GAME_CONFIG.DESIGN_W/2,15)
	
	--解析和加载
	print("***************************************")
	print("开始预加载......")
	local tmStart = os.clock()
	local tmOrigin = tmStart
	local TotalMod = #ModFileList
	local CurIndex = 0
	theScene:scheduleUpdateWithPriorityLua(function(dt)
		CurIndex = CurIndex + 1
		if ModFileList[CurIndex] then
			require(ModFileList[CurIndex])
			theProgBar:setPercent(CurIndex/TotalMod*100)
			theLabel:setString( string.format("资源加载中（%d%%）... ...",CurIndex/TotalMod*100) )
			print( string.format("进度：%d/%d  用时：%f  模块：%s", CurIndex, TotalMod, os.clock()-tmStart, ModFileList[CurIndex]) )
			tmStart = os.clock()
		else 
			if CurIndex == TotalMod+1 then
				print( string.format("加载完成，用时%f秒",os.clock()-tmOrigin) )
				print("***************************************")
				xpcall(main, __G__TRACKBACK__)
			end
		end
	end, 0)
end

--------------------------------分割线----------------------------------

xpcall(StartUp, __G__TRACKBACK__)

