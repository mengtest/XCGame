require "src/logic/scene/loginScene"
require "src/logic/scene/restScene"
require "src/logic/scene/journeyScene"
require "src/logic/scene/fightScene"

local SCENE_CFG = {
--	scenekey				  class_name		 	scene_id	map_id
	--”Œœ∑≥°æ∞
	["login_scene"] 	=  	{ clsname = clsLoginScene },
	["rest_scene"]  	=  	{ clsname = clsRestScene, 		scene_id = 3001,	map_id = 3001, },
	["journey_scene"]  	=  	{ clsname = clsJourneyScene, 	scene_id = 1001,	map_id = 1001, },
	["fight_scene"]  	= 	{ clsname = clsFightScene, 		scene_id = 2001,	map_id = 2001, },
}
for scenekey, info in pairs(SCENE_CFG) do
	REG_SCENE_CFG(scenekey, info)
end
SCENE_CFG = nil 
