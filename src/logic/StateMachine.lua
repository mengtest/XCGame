---------------------
-- 游戏状态机
---------------------
--local FSM_LAUNCH = -1		--更新版本（更新引擎 更新脚本 更新资源） 在launcher中做
local FSM_NONE = "初始"
local FSM_LOGIN = "登录"
local FSM_CHOOSE_SERVER = "选服"
local FSM_CHOOSE_ROLE = "选角or创角"
local FSM_GAMING = "游戏中"
local FSM_PAUSE_GAME = "游戏暂停"
local FSM_STOPGAME = "结束游戏"
local FROM_TABLE = {
	[FSM_NONE] = { [FSM_NONE]=true },
	[FSM_LOGIN] = { [FSM_NONE]=true,[FSM_CHOOSE_SERVER]=true,[FSM_CHOOSE_ROLE]=true,[FSM_STOPGAME]=true },
	[FSM_CHOOSE_SERVER] = { [FSM_LOGIN]=true,[FSM_CHOOSE_ROLE]=true,[FSM_STOPGAME]=true },
	[FSM_CHOOSE_ROLE] = { [FSM_CHOOSE_SERVER]=true,[FSM_STOPGAME]=true },
	[FSM_GAMING] = { [FSM_CHOOSE_ROLE]=true,[FSM_PAUSE_GAME]=true },
	[FSM_PAUSE_GAME] = { [FSM_GAMING]=true },
	[FSM_STOPGAME] = { [FSM_NONE]=true,[FSM_LOGIN]=true,[FSM_CHOOSE_SERVER]=true,[FSM_CHOOSE_ROLE]=true,[FSM_GAMING]=true,[FSM_PAUSE_GAME]=true },
}


ClsStateMachine = class("ClsStateMachine")
ClsStateMachine.__is_singleton = true

function ClsStateMachine:ctor()
	self._curState = FSM_NONE
	self.m_GameInst = nil
end

--启动
function ClsStateMachine:StartUp()
	print("\n \n \n*****************************************")
	print("状态机: 启动")
	network:Start()
	self:ToStateLogin()
end

--重新登录
function ClsStateMachine:ReLogin()
	print("重新登录")
	self:_ToStateStopGame()
	self:ToStateLogin()
end

--退出程序
function ClsStateMachine:ExitApp()
	self:ToStatePauseGame()

	local panel = ClsUIManager.GetInstance():ShowDialog("clsConfirmDlg")
	panel:Refresh("退出游戏", "您确定退出游戏？", 
		function()
			print("状态机: ToStateExitApp")
			self:_ToStateStopGame()
			KE_SetTimeout(1, function()
				ClsApp.GetInstance():Exit()
			end)
		end,
		function()
			self:ToStateResumeGame()
		end
	)
end

---------------------
-- 以下状态转换接口
---------------------
function ClsStateMachine:_CanToState(toState)
	if not FROM_TABLE[toState][self._curState] then
		assert(false, string.format("不能从状态【%s】转换到状态【%s】",self._curState,toState))
		return false
	end
	log_normal(string.format("状态机：%s ---> %s",self._curState,toState))
	return true
end

--登录
function ClsStateMachine:ToStateLogin()
	if not self:_CanToState(FSM_LOGIN) then return false end
	self._curState = FSM_LOGIN
	
	redpoint.ClsRedPointManager.GetInstance():StopWork()
	ClsUIManager.GetInstance():DestroyAllWindow()
	KE_Director:ClearUserDatas()
	
	CheckMemoryLeak()
	
	ClsSceneMgr.GetInstance():Turn2Scene("login_scene")
	
	KE_Director:InitUserDatas()
end

--选服
function ClsStateMachine:ToStateChooseServer()
	if not self:_CanToState(FSM_CHOOSE_SERVER) then return false end
	self._curState = FSM_CHOOSE_SERVER
	
	self:ToStateChooseRole()
end

--选角
function ClsStateMachine:ToStateChooseRole()
	if not self:_CanToState(FSM_CHOOSE_ROLE) then return false end
	self._curState = FSM_CHOOSE_ROLE
end

--进入游戏
function ClsStateMachine:ToStateGameing()
	if not self:_CanToState(FSM_GAMING) then return false end
	self._curState = FSM_GAMING
	
	ClsUIManager.GetInstance():DestroyAllWindow()
	self.m_GameInst = clsGame.GetInstance()
	self.m_GameInst:StartGame()
	FireGlobalEvent("ENTER_GAME")
	ClsAdvertiseManager.GetInstance():CheckLoginAdver()
	redpoint.ClsRedPointManager.GetInstance():StartWork()
end

--暂停游戏
function ClsStateMachine:ToStatePauseGame()
	if not self:_CanToState(FSM_PAUSE_GAME) then return false end
	self._curState = FSM_PAUSE_GAME
	
	if self.m_GameInst then
		self.m_GameInst:PauseGame()
	end
end

--恢复游戏
function ClsStateMachine:ToStateResumeGame()
	if not self:_CanToState(FSM_GAMING) then return false end
	self._curState = FSM_GAMING
	
	if self.m_GameInst then
		self.m_GameInst:ResumeGame()
	end
end

--结束游戏（私有方法）
function ClsStateMachine:_ToStateStopGame()
	if not self:_CanToState(FSM_STOPGAME) then return false end
	self._curState = FSM_STOPGAME
	
	if self.m_GameInst then
		clsGame:DelInstance()
		self.m_GameInst = nil
	end
	ClsUIManager.GetInstance():DestroyAllWindow()
	ClsSceneMgr.GetInstance():GetCurScene():OnDestroy()
	FireGlobalEvent("EXIT_GAME")
end
