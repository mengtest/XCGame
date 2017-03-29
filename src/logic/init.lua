-----------------------------
-- 游戏逻辑框架
-----------------------------

-- 
require "src/logic/foundation/init"

-- 战斗队伍
require "src/logic/fight_team/init"

-- 子弹
require "src/logic/bullet/init"
-- 角色
require "src/logic/role_system/init"

-- 技能系统
require "src/logic/skill/init"

-- 战斗系统
require "src/logic/fight_system/init"

-- 功能模块子系统
require "src/logic/modules/init"	--管理器
require "src/logic/ui/init"			--视图
require "src/logic/scene/init"		--场景

-- 游戏API
require "src/logic/api_center.lua"

-- 游戏实例
require "src/logic/Game"

-- 游戏状态机
require "src/logic/StateMachine"
