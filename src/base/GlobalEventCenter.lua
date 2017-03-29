------------------------
-- 全局事件中心
------------------------
g_EventMgr = clsEventSource.new()

--APP事件
g_EventMgr:RegisterEventType("APP_ENTER_BACKGROUND")	--切入后台
g_EventMgr:RegisterEventType("APP_ENTER_FOREGROUND")	--切回前台
--游戏状态机
g_EventMgr:RegisterEventType("ENTER_GAME")				--进入游戏
g_EventMgr:RegisterEventType("EXIT_GAME")				--离开游戏
--网络事件
g_EventMgr:RegisterEventType("NETEVENT_CONNECTED")		--连接成功
g_EventMgr:RegisterEventType("NETEVENT_DISCONNECTED")	--断网
g_EventMgr:RegisterEventType("RECIEVE_PTO")				--收到协议
g_EventMgr:RegisterEventType("SEND_PTO")				--发送协议
--场景切换
g_EventMgr:RegisterEventType("LEAVE_SCENE")				--离开场景
g_EventMgr:RegisterEventType("ENTER_SCENE")				--进入场景
--地图切换
g_EventMgr:RegisterEventType("LEAVE_WORLD")				--离开地图
g_EventMgr:RegisterEventType("ENTER_WORLD")				--进入地图
--战斗事件
g_EventMgr:RegisterEventType("START_COMBAT")			--战斗开始
g_EventMgr:RegisterEventType("END_COMBAT")				--战斗结束
--队伍事件
g_EventMgr:RegisterEventType("NEW_TEAM")				--有新队伍成立
g_EventMgr:RegisterEventType("DEL_TEAM")				--有队伍解散
g_EventMgr:RegisterEventType("TEAM_ADD_MEMBER")			--成员入队
g_EventMgr:RegisterEventType("TEAM_DEL_MEMBER")			--成员离队
g_EventMgr:RegisterEventType("TEAM_RELATION_CHG")		--队伍间敌友关系变更
--角色事件
g_EventMgr:RegisterEventType("ROLE_DIE")				--角色死亡

------------------------------------------------------

function FireGlobalEvent(evt_name, ...)
	g_EventMgr:FireEvent(evt_name, ...)
end

