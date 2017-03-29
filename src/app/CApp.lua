------------------
-- 配置
------------------
ClsApp = class("ClsApp")

function ClsApp:ctor()
	self:InitGLEnviroument()
	self:InitAppEvents()
	self:SetupConfig()
end

function ClsApp:dtor()
	self:Exit()
end

function ClsApp:Run()
	
end

function ClsApp:Exit()
    cc.Director:getInstance():endToLua()
    if device.platform == "windows" or device.platform == "mac" then
        os.exit()
    end
end

-- 初始化director和glview
function ClsApp:InitGLEnviroument()
	local theDirector = cc.Director:getInstance()
	local theGLView = theDirector:getOpenGLView()
	
	if nil == theGLView then
		theGLView = cc.GLView:create("KuEngine")
	    theDirector:setOpenGLView(theGLView)
	end
end

-- 初始化App事件
function ClsApp:InitAppEvents()
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	
    local customListenerBg = cc.EventListenerCustom:create("event_come_to_background",function()
    	print("切入后台了...")
    	FireGlobalEvent("APP_ENTER_BACKGROUND")
    end)
    eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
    
    local customListenerFg = cc.EventListenerCustom:create("event_come_to_foreground",function()
    	print("切回前台了...")
    	FireGlobalEvent("APP_ENTER_FOREGROUND")
    end)
    eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)
end

function ClsApp:SetupConfig()
	local theDirector = cc.Director:getInstance()
	local theGLView = theDirector:getOpenGLView()
	
	-- 屏幕适配
--	theGLView:setDesignResolutionSize(GAME_CONFIG.DESIGN_W, GAME_CONFIG.DESIGN_H, cc.ResolutionPolicy.SHOW_ALL)
	-- 是否显示调试信息
	theDirector:setDisplayStats(GAME_CONFIG.ShowFps)
	-- 帧率
	theDirector:setAnimationInterval(1.0 / GAME_CONFIG.FPS)
	-- 设置默认像素格式
	cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	-- 设置投影模式
	theDirector:setProjection(cc.DIRECTOR_PROJECTION2_D)
end
