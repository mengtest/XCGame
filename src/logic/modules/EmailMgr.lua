----------------
-- Email管理器
----------------
local clsEmailData = class("clsEmailData", clsDataFace)

clsEmailData:RegSaveVar("Uid", TYPE_CHECKER.INT)				--EmailId
clsEmailData:RegSaveVar("Title", TYPE_CHECKER.STRING)			--标题
clsEmailData:RegSaveVar("SenderId", TYPE_CHECKER.INT)			--发件人ID
clsEmailData:RegSaveVar("SenderName", TYPE_CHECKER.STRING)		--发件人名字
clsEmailData:RegSaveVar("Content", TYPE_CHECKER.STRING)			--内容
clsEmailData:RegSaveVar("Attachment", TYPE_CHECKER.TABLE_NIL)	--附件
clsEmailData:RegSaveVar("Date", TYPE_CHECKER.INT)				--发送日期
clsEmailData:RegSaveVar("State", TYPE_CHECKER.INT)				--状态：未读，已读，已领取

function clsEmailData:ctor(iUid)
	clsDataFace.ctor(self)
	self:SetUid(iUid)
end

function clsEmailData:dtor()
	
end

------------------------------------------------------------

clsEmailManager = class("clsEmailManager", clsCoreObject)
clsEmailManager.__is_singleton = true

function clsEmailManager:ctor()
	clsCoreObject.ctor(self)
	self.tEmailList = {}
end

function clsEmailManager:dtor()
	
end

function clsEmailManager:AddEmail(EmailId, Info)
	self.tEmailList[EmailId] = self.tEmailList[EmailId] or clsEmailData.new(EmailId)
	self.tEmailList[EmailId]:BatchSetAttr(Info)
end

function clsEmailManager:DelEmail(EmailId)
	if self.tEmailList[EmailId] then
		KE_SafeDelete(self.tEmailList[EmailId])
		self.tEmailList[EmailId] = nil 
	end
end

function clsEmailManager:ReadEmail(EmailId)
	local EmailData = self.tEmailList[EmailId]
	if not EmailData then return end
	EmailData:SetState(2)
	if not Attachment or #Attachment <= 0 then
		EmailData:SetState(3)
	end
end

function clsEmailManager:DrawEmail(EmailId)
	local EmailData = self.tEmailList[EmailId]
	local Attachment = EmailData and EmailData:GetAttachment() 
	if Attachment and #Attachment > 0 then
		print("领取附件")
	end
	self.tEmailList[EmailId]:SetState(3)
end
