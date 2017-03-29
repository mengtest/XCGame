-- 平台相关
require "src/core/platforms/KeyBoard"

-- cocos扩展
require "src/core/cocos_ext/init"

-- Group抽象类
require "src/core/group/init"
-- 物理碰撞检测空间
require "src/core/physics/init"

-- 资源管理器
require "src/core/manager/init"

require "src/core/helper/init"
-- 环境定义（Scene和UI）
require "src/core/environment/init"
-- 2d地图
require "src/core/map2d/init"
-- 组件定义（list, button check_group等）
require "src/core/components/init"
-- 特效
require "src/core/effect/init"

-- 动作播放系统
require "src/core/action_tree/init"

-- AI系统
require "src/core/ai/init"

-- 指引系统
require "src/core/guide/init"

-- 串行动作管理
require "src/core/procedure/init"