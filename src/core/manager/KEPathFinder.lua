--------------
-- 寻路器
--------------

ClsPathFinder = class("ClsPathFinder")
ClsPathFinder.__is_singleton = true

function ClsPathFinder:ctor()

end

function ClsPathFinder:dtor()

end

--A星寻路
function ClsPathFinder:FindPath(sx, sy, dx, dy, distance)
	if distance == nil then distance = 0 end
	
	local X, Y = dx-sx, dy-sy
	local LenSqure = X*X + Y*Y
	local disSqure = distance * distance
	if LenSqure <= disSqure then 
		return {
			get_next = function(this, inc)
				return sx, sy, nil, true
			end,
		}
	end
	
	
	local dir = math.Vector2Radian(X, Y)
	-- 生成路径
	local roadPath = {
		iPathedLen = 0,
		get_next = function(this, inc)
			this.iPathedLen = this.iPathedLen + inc
			local curDir = dir
			
			if this.iPathedLen*this.iPathedLen >= LenSqure-disSqure then
				this.iPathedLen = math.sqrt(LenSqure-disSqure)
				return sx+this.iPathedLen*math.cos(dir), sy+this.iPathedLen*math.sin(dir), curDir, true
			else
				return sx+this.iPathedLen*math.cos(dir), sy+this.iPathedLen*math.sin(dir), curDir, false
			end
		end,
	}
	
	return roadPath
end

--沿某方向直线移动，遇到障碍点则停止
function ClsPathFinder:FindPathLine(sx, sy, iDir, iSpeed, iDistance)
	if iDistance==0 then 
		return {
			get_next = function(this, inc)
				return sx, sy, true
			end
		}
	end
	
	-- 生成路径
	local roadPath = {
		iTotalFrame = math.ceil(iDistance/iSpeed),
		iCurFrame = 0,
		iMoveDeltaX = iSpeed*math.cos(iDir),
		iMoveDeltaY = iSpeed*math.sin(iDir),
		iDstX = sx + iDistance*math.cos(iDir),
		iDstY = sy + iDistance*math.sin(iDir),
		get_next = function(this)
			this.iCurFrame = this.iCurFrame + 1
			if this.iCurFrame >= this.iTotalFrame then
				return this.iDstX, this.iDstY, true
			else
				return sx+this.iCurFrame*this.iMoveDeltaX, sy+this.iCurFrame*this.iMoveDeltaY, false
			end
		end,
	}
	
	return roadPath
end
