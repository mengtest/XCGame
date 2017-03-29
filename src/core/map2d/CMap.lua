----------------------------
-- 地图类
-- 瓦片下标从(0,0)开始，左下角为第0行第0列
-- 1024*1024 == 1M == (256*256*4)*4   即1个256*256的地图块为1/4M
----------------------------
local math_limit = math.Limit

local LAYER_LAND = const.LAYER_LAND
local LAYER_OBJ = const.LAYER_OBJ
local LAYER_WEATHER = const.LAYER_WEATHER

local MAX_TILE_COUNT = 32
local QUICK_INDEX = {}
for Row = 0, MAX_TILE_COUNT do
	QUICK_INDEX[Row] = QUICK_INDEX[Row] or {}
	for Col = 0, MAX_TILE_COUNT do
		QUICK_INDEX[Row][Col] = string.format("%d_%d", Row, Col)
	end
end


clsMap = class("clsMap", clsGameLayer)

function clsMap:ctor(parent, map_id, bLockCamera)
	clsGameLayer.ctor(self, const.ORDER_MAP_LAYER, parent)
	assert(map_id)
	
	self._bCameraLocked = bLockCamera and true or false 
	self.tLayerList = {}
	self.iMapId = map_id
	self.tMapBlockCache = {}
	self.tMapInfo = {}
	self.cur_blocks = {}
	self._r0,self._r1 = -1,-1
	self._c0,self._c1 = -1,-1
	self._xCenter = 0
	self._yCenter = 0
	self._x0 = 0
	self._y0 = 0
	self._x1 = 0
	self._y1 = 0
	
	self.mRootNode = cc.Layer:create()
	KE_SetParent(self.mRootNode, self)
	
	self:ReadMapHeader()
	self:InitCompLoader()
	self:init_layers()
	self:init_events()
	
	KE_TheMap = self
	
	FireGlobalEvent("ENTER_WORLD")
	
	self:InitKeyBoardListener()
end

function clsMap:dtor()
	ClsUpdator.GetInstance():UnregisterUpdator(self.OnUpdate, self) 
	self:BindCameraOn(nil)
	self._bCameraLocked = true
	FireGlobalEvent("LEAVE_WORLD")
	
	if self.mCompLoader then
		KE_SafeDelete(self.mCompLoader)
		self.mCompLoader = nil 
	end
	
	for _, gamelayer in pairs(self.tLayerList) do
		KE_SafeDelete(gamelayer)
	end
	self.tLayerList = {}
	KE_TheMap = nil
end

function clsMap:init_layers()
	self.tLayerList[LAYER_LAND] = clsGameLayer.new(LAYER_LAND, self.mRootNode)
	self.tLayerList[LAYER_OBJ] = clsGameLayer.new(LAYER_OBJ, self.mRootNode)
	self.tLayerList[LAYER_WEATHER] = clsGameLayer.new(LAYER_WEATHER, self.mRootNode)
end

function clsMap:ReadMapHeader()
	local filepath = string.format("res/map/%d/%d.lua", self.iMapId, self.iMapId)
	local data = io.SafeLoadFile(filepath)
	assert(data.row_count<=MAX_TILE_COUNT and data.col_count<=MAX_TILE_COUNT, "最大瓦片行数和列数为："..MAX_TILE_COUNT)
	
	self.tMapInfo = {
		["tile_width"] = data.tile_width,			--瓦片宽
		["tile_height"] = data.tile_height,			--瓦片高
		["row_count"] = data.row_count,				--多少行瓦片
		["col_count"] = data.col_count,				--多少列瓦片
		["map_width"] = data.map_width,				--地图实际宽
		["map_height"] = data.map_height,			--地图实际高
		["img_format"] = data.img_format or "jpg",	--图片格式（jpg/png/tga/psd/...）
	}
	
	self._iMinXCenter = GAME_CONFIG.DESIGN_W_2
	self._iMaxXCenter = self.tMapInfo.map_width - GAME_CONFIG.DESIGN_W_2
	self._iMinYCenter = GAME_CONFIG.DESIGN_H_2
	self._iMaxYCenter = self.tMapInfo.map_height - GAME_CONFIG.DESIGN_H_2
	
	local map_index_2_path = {}
	for r = 0, MAX_TILE_COUNT do
		for c = 0, MAX_TILE_COUNT do
			local sIndex = QUICK_INDEX[r][c]
			map_index_2_path[sIndex] = string.format("res/map/%d/%s.%s", self.iMapId, sIndex, self.tMapInfo.img_format)
		end
	end
	self._map_index_2_path = map_index_2_path
end

function clsMap:GetUid() return self.iMapId end
function clsMap:GetMapInfo() return self.tMapInfo end
function clsMap:GetMapWidth() return self.tMapInfo.map_width end
function clsMap:GetMapHeight() return self.tMapInfo.map_height end
function clsMap:GetTileWidth() return self.tMapInfo.tile_width end
function clsMap:GetTileHeight() return self.tMapInfo.tile_height end

function clsMap:WorldPos_2_Tile(world_x, world_y)
	return math.floor(world_y/self.tMapInfo.tile_height), math.floor(world_x/self.tMapInfo.tile_width)
end
function clsMap:Tile_2_WorldPos(r, c)
	-- 返回的是Tile左下角坐标点
	return c*self.tMapInfo.tile_width, r*self.tMapInfo.tile_height
end
function clsMap:WorldPos_2_ScreenPos(x, y)
	return x-self._x0, y-self._y0
end
function clsMap:ScreenPos_2_WorldPos(x, y)
	return self._x0+x, self._y0+y
end
function clsMap:GetMapBlockIndex(r, c)
	return QUICK_INDEX[r][c]
end
function clsMap:GetMapBlockPath(r, c)
	return self._map_index_2_path[ QUICK_INDEX[r][c] ]
end
function clsMap:GetMapBlockPathByIndex(index)
	return self._map_index_2_path[index]
end

function clsMap:LoadBlock(r, c)
	local index = QUICK_INDEX[r][c]
	if not self.tMapBlockCache[index] then
		local res_path = self:GetMapBlockPath(r, c)
		self.tMapBlockCache[index] = cc.Sprite:create(res_path)
		self.tMapBlockCache[index]:setIgnoreAnchorPointForPosition(true)
		KE_SetParent(self.tMapBlockCache[index], self.tLayerList[LAYER_LAND])
		local x, y = self:Tile_2_WorldPos(r, c)
		self.tMapBlockCache[index]:setPosition(x, y)
	end
	
	self:LoadCfgData(r,c)
end

function clsMap:UnloadBlock(index)
	if self.tMapBlockCache[index] then
		KE_SafeDelete(self.tMapBlockCache[index])
		self.tMapBlockCache[index] = nil
		cc.Director:getInstance():getTextureCache():removeTextureForKey(self:GetMapBlockPathByIndex(index))
	end
end

function clsMap:LoadBlockAsync(r, c)
	local index = QUICK_INDEX[r][c]
	if self.tMapBlockCache[index] then return end
	
	local function imageLoaded(texture)
		if self.tMapBlockCache[index] then return end
		self.tMapBlockCache[index] = cc.Sprite:createWithTexture(texture)
		self.tMapBlockCache[index]:setIgnoreAnchorPointForPosition(true)
		KE_SetParent(self.tMapBlockCache[index], self.tLayerList[LAYER_LAND])
		local x, y = self:Tile_2_WorldPos(r, c)
		self.tMapBlockCache[index]:setPosition(x, y)
    end
	cc.Director:getInstance():getTextureCache():addImageAsync(self:GetMapBlockPath(r, c), imageLoaded)
	
	self:LoadCfgData(r,c)
end

function clsMap:UnloadBlockAsync(index)
	if self.tMapBlockCache[index] then
		KE_SafeDelete(self.tMapBlockCache[index])
		self.tMapBlockCache[index] = nil
		cc.Director:getInstance():getTextureCache():removeTextureForKey(self:GetMapBlockPathByIndex(index))
	else
		cc.Director:getInstance():getTextureCache():unbindImageAsync(self:GetMapBlockPathByIndex(index))
	end
end

-- 输入：相机坐标
-- 确定可视区域
function clsMap:CalSeeableArea(xCenter, yCenter)
	xCenter = math_limit(xCenter, self._iMinXCenter, self._iMaxXCenter)
	yCenter = math_limit(yCenter, self._iMinYCenter, self._iMaxYCenter)
	
	if xCenter == self._xCenter and yCenter == self._yCenter then 
		return false 
	end
	
	self._xCenter = xCenter
	self._yCenter = yCenter
	self._x0 = xCenter - GAME_CONFIG.DESIGN_W_2
	self._y0 = yCenter - GAME_CONFIG.DESIGN_H_2
	self._x1 = self._x0 + GAME_CONFIG.DESIGN_W
	self._y1 = self._y0 + GAME_CONFIG.DESIGN_H
	
	return true
end

-- 加载可见地图块
function clsMap:UpdateCurBlocks()
	local r0, c0 = self:WorldPos_2_Tile(self._x0, self._y0)
	local r1, c1 = self:WorldPos_2_Tile(self._x1, self._y1)
	
	if self._r0>r0 or self._r1<r1 or self._c0>c0 or self._c1<c1 then
		r0 = r0-4  if r0<0 then r0=0 end
		c0 = c0-4  if c0<0 then c0=0 end
		r1 = r1+4  if r1>self.tMapInfo.row_count-1 then r1=self.tMapInfo.row_count-1 end
		c1 = c1+4  if c1>self.tMapInfo.col_count-1 then c1=self.tMapInfo.col_count-1 end
		self._r0,self._r1 = r0,r1
		self._c0,self._c1 = c0,c1
		
		self.visible_flag = not self.visible_flag
		
		local new_visible_flag = self.visible_flag
		local cur_blocks = self.cur_blocks
		
		for i=r0, r1 do
			for j=c0, c1 do
				self:LoadBlockAsync(i,j)
				cur_blocks[QUICK_INDEX[i][j]] = new_visible_flag
			end
		end
		
		for index, flag in pairs(cur_blocks) do
			if flag ~= new_visible_flag then 
				cur_blocks[index] = nil
				self:UnloadBlockAsync(index)
			end
		end
	end
end

function clsMap:SetCameraPos(x, y)
	if self:CalSeeableArea(x,y) then
		-- 通过反向移动地图的方式来模拟相机移动
		self:setPosition(-self._x0, -self._y0)
		-- 加载可见地图块
		self:UpdateCurBlocks()
	end
end

function clsMap:GetCameraPos()
	return self._x0, self._y0
end

--[[
function clsMap:OnUpdate(deltaTime)
	if self._mCameraBinder then 
		self:SetCameraPos(self._mCameraBinder:getPosition())
	end
end

function clsMap:BindCameraOn(obj)
	ClsUpdator.GetInstance():UnregisterUpdator(self.OnUpdate, self)
	self._mPreCameraBinder = self._mCameraBinder
	self._mCameraBinder = obj
	if obj then
		ClsUpdator.GetInstance():RegisterUpdator(self.OnUpdate, self, ClsUpdator.ORDER_CAMERA)
	end
end
]]--

-- 锁定相机后，将禁止绑定相机跟随
function clsMap:LockCamera()
	self:BindCameraOn(nil)
	self._bCameraLocked = true
end

function clsMap:UnLockCamera()
	self._bCameraLocked = false
end

function clsMap:SetTouchMoveEnabled(bEnable)
	self._bTouchMoveEnabled = bEnable
	assert(not self._mCameraBinder, "尚未移除相机跟随")
end

function clsMap:BindCameraOn(obj)
	if self._bCameraLocked then
		assert(not obj, "相机处于被锁状态：禁止在此时绑定相机跟随")
		return 
	end
	if self._mCameraBinder == obj then return end
	
	local preBinder = self._mCameraBinder
	if preBinder then
		--
		assert(preBinder._origin_set_position)
		preBinder.setPosition = preBinder._origin_set_position
		preBinder._origin_set_position = nil
		--
		assert(preBinder._origin_set_position_x)
		preBinder.setPositionX = preBinder._origin_set_position_x
		preBinder._origin_set_position_x = nil
		--
		assert(preBinder._origin_set_position_y)
		preBinder.setPositionY = preBinder._origin_set_position_y
		preBinder._origin_set_position_y = nil
	end
	
	self._mCameraBinder = obj
	if tolua.isnull(obj) then self._mCameraBinder = nil end
	
	if obj then
		KE_ExtendClass(obj)
		obj:AddScriptHandler(const.CORE_EVENT.cleanup, function()
			self._mCameraBinder = nil 
		end)
		
		--
		assert(not obj._origin_set_position)
		obj._origin_set_position = obj.setPosition
		obj.setPosition = function(this, x, y)
			this:_origin_set_position(x,y)
			self:SetCameraPos(x,y)
		end
		--
		assert(not obj._origin_set_position_x)
		obj._origin_set_position_x = obj.setPositionX
		obj.setPositionX = function(this, x)
			this:_origin_set_position_x(x)
			self:SetCameraPos(x, self._yCenter)
		end
		--
		assert(not obj._origin_set_position_y)
		obj._origin_set_position_y = obj.setPositionY
		obj.setPositionY = function(this, y)
			this:_origin_set_position_y(y)
			self:SetCameraPos(self._xCenter, y)
		end
	end
end

function clsMap:GetCameraBinder()
	return self._mCameraBinder
end

function clsMap:GetPreCameraBinder()
	return self._mPreCameraBinder
end

------------------------------------------------------------

function clsMap:InitCompLoader()
	if self.mCompLoader then return self.mCompLoader end
	
	local filepath = string.format("src/data/scenemap_cfgs/%d.lua", self.iMapId)
	local Info = table.clone( io.SafeLoadFile(filepath) )
	
	self.mCompLoader = helper.clsCompLoader.new()
	self._UnLoadedChildrens = Info.Childrens
	
	if self._UnLoadedChildrens then
		for _, ChildInfo in ipairs(self._UnLoadedChildrens) do
			local Attr = ChildInfo.Attr
			local x, y = Attr.tPos[1] or 0, Attr.tPos[2] or 0
			ChildInfo._TilePosRow, ChildInfo._TilePosCol = self:WorldPos_2_Tile(x, y)
		end
	end
	
	return self.mCompLoader
end

function clsMap:LoadCfgData(r, c)
	local LoadList = self._UnLoadedChildrens
	if not LoadList or #LoadList==0 then return end
	
--	local OldLen = #LoadList
	for i=#LoadList, 1, -1 do
		if LoadList[i]._TilePosRow == r and LoadList[i]._TilePosCol == c then
			self.mCompLoader:CreateCompByCfgInfo(LoadList[i], self.tLayerList[LAYER_OBJ])
			table.remove(LoadList, i)
		end
	end
--	print(OldLen, "---->", #LoadList)
end

------------------------------------------------------------

function clsMap:AddObject(obj, x, y)
	if not obj then return false end
	KE_SetParent(obj, self.tLayerList[LAYER_OBJ])
	if x and y then obj:setPosition(x, y) end
	return true
end

function clsMap:RemoveObject(obj)
	if self._mCameraBinder == obj then
		self._mCameraBinder = nil
	end
	if self._mPreCameraBinder == obj then
		self._mPreCameraBinder = nil
	end
end

------------------------------------------------------------

function clsMap:init_events()
	local WAIT_FRAMES = math.ceil(utils.Second2Frame(0.33))
	self._PreFrame = ClsTimerMgr.GetInstance():GetPassedFrame()
	
	local function onTouchBegan(touch, event)
		return true
	end
	local function onTouchMoved(touch, event)
		if self._bTouchMoveEnabled then 
			local dt = touch:getDelta()
			self:SetCameraPos(self._xCenter-dt.x, self._yCenter-dt.y)
		end
	end
	local function onTouchEnded(touch, event)
		local opTarget = ClsRoleMgr.GetInstance():GetHero()
		if opTarget then
			local PreFrame = self._PreFrame
			self._PreFrame = ClsTimerMgr.GetInstance():GetPassedFrame()
			local ptTouch = touch:getLocation()
			local x, y = self:ScreenPos_2_WorldPos(ptTouch.x, ptTouch.y)	--等价于convertToNodeSpace

			if self._PreFrame-PreFrame < WAIT_FRAMES then
				local x0,y0 = opTarget:getPosition()
				local hudu = math.Vector2Radian(x-x0,y-y0)
				if hudu then
					local dis = 380
					local dx, dy = x0+dis*math.cos(hudu), y0+dis*math.sin(hudu)
					opTarget:CallRush(dx, dy, nil, function() end, function() end)
				end
			else
				opTarget:CallRun(x, y, nil, function() end, function() end)
			end
		end
	end
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function clsMap:Shake(seconds, degree, OnFinish)
	local root_node = self.mRootNode

	local delta = 0.02
	local actShakeOnce = cc.Sequence:create(
			cc.MoveTo:create(delta, cc.p(5, 20)), 
			cc.MoveTo:create(delta, cc.p(0, 0)), 
			cc.MoveTo:create(delta, cc.p(-5, -20)), 
			cc.MoveTo:create(delta, cc.p(0, 0)) )
			
	root_node.shake_act = root_node:runAction(cc.Sequence:create(
		cc.Repeat:create(actShakeOnce, 4),
		cc.CallFunc:create(function()
			root_node.shake_act = nil
			root_node:setPosition(0,0)
			
			if OnFinish then
				OnFinish()
			end	
		end)
	))
end

function clsMap:StopShake()
	local root_node = self.mRootNode
	if root_node.shake_act then
		root_node:stopAction(root_node.shake_act)
		root_node.shake_act = nil
		root_node:setPosition(0,0)
	end
end

function clsMap:InitKeyBoardListener()
	local function MoveHero()
		local opTarget = self._mCameraBinder or ClsRoleMgr.GetInstance():GetHero()
		if not opTarget then return end
		
		local dx,dy = 0,0
		
		if keyboard:IsKeyPressed(cc.KeyCode.KEY_W) then
			dy = 5000
		elseif keyboard:IsKeyPressed(cc.KeyCode.KEY_S) then
			dy = -5000
		end
		if keyboard:IsKeyPressed(cc.KeyCode.KEY_D) then
			dx = 5000
		elseif keyboard:IsKeyPressed(cc.KeyCode.KEY_A) then
			dx = -5000
		end
		
		if dx~=0 or dy~=0 then
			if keyboard:IsKeyPressed(cc.KeyCode.KEY_SHIFT) then
				opTarget:CallRush(opTarget:getPositionX()+dx, opTarget:getPositionY()+dy)
			else
				opTarget:CallRun(opTarget:getPositionX()+dx, opTarget:getPositionY()+dy)
			end
		else
			opTarget:CallRest()
		end
	end
	
	local function onKeyPressed(key_code, event)
		local opTarget = self._mCameraBinder or ClsRoleMgr.GetInstance():GetHero()
		
		-- 移动
		if key_code == cc.KeyCode.KEY_A then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_D then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_W then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_S then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_SHIFT then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_K then
			if opTarget then
				opTarget:CallJump(opTarget:getPositionX(),opTarget:getPositionY())
			end
		end
		
		-- 技能
		if opTarget then
			if key_code == cc.KeyCode.KEY_J then
				if not opTarget:GetAiBrain():GetTaskById("fight_cmd_atk") then
					local objTask = ai.clsBtTask.new("fight_cmd_atk", "bt_attack_1", opTarget, 0)
					opTarget:GetAiBrain():AddSerialTaskFirst(objTask)
				end
			elseif key_code == cc.KeyCode.KEY_U then
				if not opTarget:GetAiBrain():GetTaskById("fight_cmd_atk") then
					local objTask = ai.clsBtTask.new("fight_cmd_atk", "bt_attack_2", opTarget, 0)
					opTarget:GetAiBrain():AddSerialTaskFirst(objTask)
				end
			elseif key_code == cc.KeyCode.KEY_I then
				if not opTarget:GetAiBrain():GetTaskById("fight_cmd_atk") then
					local objTask = ai.clsBtTask.new("fight_cmd_atk", "bt_attack_3", opTarget, 0)
					opTarget:GetAiBrain():AddSerialTaskFirst(objTask)
				end
			elseif key_code == cc.KeyCode.KEY_O then
				if not opTarget:GetAiBrain():GetTaskById("fight_cmd_atk") then
					local objTask = ai.clsBtTask.new("fight_cmd_atk", "bt_attack_4", opTarget, 0)
					opTarget:GetAiBrain():AddSerialTaskFirst(objTask)
				end
			elseif key_code == cc.KeyCode.KEY_L then
				if not opTarget:GetAiBrain():GetTaskById("fight_cmd_atk") then
					local objTask = ai.clsBtTask.new("fight_cmd_atk", "bt_attack_5", opTarget, 0)
					opTarget:GetAiBrain():AddSerialTaskFirst(objTask)
				end
			elseif key_code == cc.KeyCode.KEY_H then
				if not opTarget:GetAiBrain():GetTaskById("fight_cmd_atk") then
					local objTask = ai.clsBtTask.new("fight_cmd_atk", "bt_attack_6", opTarget, 0)
					opTarget:GetAiBrain():AddSerialTaskFirst(objTask)
				end
			elseif key_code == cc.KeyCode.KEY_SPACE then
				
			end
		end
		
		-- 状态测试
		if opTarget then
			if key_code == cc.KeyCode.KEY_F1 then
				opTarget:TestHitBack()		--击退
			elseif key_code == cc.KeyCode.KEY_F2 then
				opTarget:TestHitFloat()		--浮空
			elseif key_code == cc.KeyCode.KEY_F3 then
				opTarget:TestFreeze()		--冻结
			elseif key_code == cc.KeyCode.KEY_F4 then
				opTarget:TestHit()			--受击
			elseif key_code == cc.KeyCode.KEY_F6 then
				opTarget:TestDie()			--死亡
			elseif key_code == cc.KeyCode.KEY_F7 then
				opTarget:TestRevive()		--复活
			elseif key_code == cc.KeyCode.KEY_F8 then
				opTarget:CallDefend()		--防御
			end
		end
		
		-- 调试
		if key_code == cc.KeyCode.KEY_Q then
			DumpDebugInfo()
		end
	end
	
	local function onKeyReleased(key_code, event)
		local opTarget = self._mCameraBinder or ClsRoleMgr.GetInstance():GetHero()
		
		if key_code == cc.KeyCode.KEY_A then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_D then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_W then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_S then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_SHIFT then
			MoveHero()
		end
	end
	
	keyboard:AddKeyPressListener(onKeyPressed)
	keyboard:AddKeyReleaseListener(onKeyReleased)
end

