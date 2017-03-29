------------------------
-- 环境配置
------------------------
local screensize = cc.Director:getInstance():getWinSize()
local _FPS = 45

LOCAL_DIR = "xcdata"

GAME_CONFIG = {
	--
	["FPS"] = _FPS,								-- 帧率
	["SPF"] = 1/_FPS,							-- 每帧有多少秒
	["ShowFps"] = true,							-- 是否显示帧率
	--
	["SCREEN_W"] = screensize.width,			-- 实际屏幕宽
	["SCREEN_H"] = screensize.height,			-- 实际屏幕高
	["SCREEN_W_2"] = screensize.width/2,		-- 实际屏幕宽/2
	["SCREEN_H_2"] = screensize.height/2,		-- 实际屏幕高/2
	--
	["DESIGN_W"] = 1280,						-- 设计宽
	["DESIGN_H"] = 720,							-- 设计高
	["DESIGN_W_2"] = 640,						-- 设计宽/2
	["DESIGN_H_2"] = 360,						-- 设计高/2
	--
	["VIEW_W"] = 1024,							-- 界面最大宽
	["VIEW_H"] = 576,							-- 界面最大高
	["VIEW_W_2"] = 512,							-- 界面最大宽/2
	["VIEW_H_2"] = 288,							-- 界面最大高/2
}
if GAME_CONFIG.SCREEN_W >= 1280 and GAME_CONFIG.SCREEN_H >= 720 then 
	GAME_CONFIG.DESIGN_W = GAME_CONFIG.SCREEN_W  
	GAME_CONFIG.DESIGN_W_2 = GAME_CONFIG.DESIGN_W/2 
	GAME_CONFIG.DESIGN_H = GAME_CONFIG.SCREEN_H  
	GAME_CONFIG.DESIGN_H_2 = GAME_CONFIG.DESIGN_H/2 
end

-------------------------------------------------------------------------------

-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = GAME_CONFIG.DESIGN_W,
    height = GAME_CONFIG.DESIGN_H,
    autoscale = "SHOW_ALL",
    callback = function(framesize)
        local ratio = framesize.height / framesize.width
        if ratio > 0.75 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "SHOW_ALL"}
        end
    end
}
