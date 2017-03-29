----------------
-- 签到管理器
----------------
clsSignInManager = class("clsSignInManager", clsCoreObject)
clsSignInManager.__is_singleton = true

clsSignInManager:RegisterEventType("sign_in")

function clsSignInManager:ctor()
	clsCoreObject.ctor(self)
	self.tSigninList = {}
end

function clsSignInManager:dtor()

end

function clsSignInManager:InitSigninList(signinlist)
	self.tSigninList = signinlist
end

function clsSignInManager:Sign(idx)
	self.tSigninList[idx].iSigned = 1
	self:FireEvent("sign_in", idx)
end

function clsSignInManager:HasSigned()
	local today = os.date("*t")
	return self.tSigninList[today.day] and self.tSigninList[today.day].iSigned == 1
end

function clsSignInManager:GetSigninList()
	return self.tSigninList
end
