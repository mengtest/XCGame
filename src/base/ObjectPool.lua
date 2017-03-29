----------------------
-- 对象池，只适合非基类且为纯脚本类
----------------------
ClsObjectPool = class("ClsObjectPool")

function ClsObjectPool:ctor(cls, incSize)
	assert(cls)
	assert(incSize>=4)
	self.cls = cls
	self.iIncSize = incSize
	self.iTotalCnt = 0
	self.tBlockList = {}
end

function ClsObjectPool:dtor()

end

function ClsObjectPool:_Increase()
	local cls = self.cls
	local incSize = self.iIncSize-1
	
	for Idx = 1, incSize do
		local obj = cls.new()  
		obj._PoolInstance_ = self
		self.tBlockList[obj] = true
	end
	local objRet = cls.new()  
	objRet._PoolInstance_ = self
	self.tBlockList[objRet] = false
	
	self.iTotalCnt = self.iTotalCnt + self.iIncSize
	
	return objRet 
end

function ClsObjectPool:AllocObject()
	for obj, isFree in pairs(self.tBlockList) do
		if isFree then
			self.tBlockList[obj] = false
			return obj
		end
	end
	
	return self:_Increase()
end

function ClsObjectPool.FreeObject(obj)
	local PoolInstance = obj._PoolInstance_
	PoolInstance.tBlockList[obj] = true
	
	if PoolInstance.iTotalCnt <= PoolInstance.iIncSize * 4 then return end
	
	for _, isFree in pairs(PoolInstance.tBlockList) do
		if isFree then
			PoolInstance.tBlockList[obj] = nil
			PoolInstance.iTotalCnt = PoolInstance.iTotalCnt - 1
			return 
		end
	end
end

function ClsObjectPool:DumpDebugInfo()
--	print("---------开始---------")
	local usedCnt = 0
	for obj, isFree in pairs(self.tBlockList) do
--		print(isFree, tostring(obj))
		if not isFree then usedCnt=usedCnt+1 end
	end
	print(string.format("池名：%s    总对象数：%d    已使用数：%d",self.cls.__cname, self.iTotalCnt, usedCnt))
--	print("---------结束---------")
end
