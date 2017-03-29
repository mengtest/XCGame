module("ai",package.seeall)

clsGoTo = class("clsGoTo", clsActionNode)

function clsGoTo:ctor(sMoveType, mapid, x, y, dis)
	clsActionNode.ctor(self)
	self.iMapId = mapid
	self.iDstX, self.iDstY = x, y
	self.iDis = dis
	self.sMoveType = sMoveType
end

function clsGoTo:Proc(theOwner)
	return theOwner:ProcGoTo(self, self.sMoveType, self.iMapId, self.iDstX, self.iDstY, self.iDis)
end

function clsGoTo:OnInterrupt(theOwner)
	theOwner:CallRest()
end
