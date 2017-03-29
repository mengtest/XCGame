---------------------
-- UI层
---------------------

clsUILayer = class("clsUILayer", clsGameLayer)

function clsUILayer:ctor(Parent)
	clsGameLayer.ctor(self, const.ORDER_UI_LAYER, Parent)
	
	self.tLayerList = {}
	
	self:init_layers()
end

function clsUILayer:dtor()
	ClsUIManager.GetInstance():DestroyAllWindow()
	
	for _, gamelayer in pairs(self.tLayerList) do
		KE_SafeDelete(gamelayer)
	end
	self.tLayerList = {}
end

function clsUILayer:init_layers()
	self.tLayerList[const.LAYER_PANEL] = clsGameLayer.new(const.LAYER_PANEL, self)
	self.tLayerList[const.LAYER_POP] = clsGameLayer.new(const.LAYER_POP, self)
	self.tLayerList[const.LAYER_TIPS] = clsGameLayer.new(const.LAYER_TIPS, self)
	self.tLayerList[const.LAYER_DLG] = clsGameLayer.new(const.LAYER_DLG, self)
	self.tLayerList[const.LAYER_GUIDE] = clsGameLayer.new(const.LAYER_GUIDE, self)
	self.tLayerList[const.LAYER_LOADING] = clsGameLayer.new(const.LAYER_LOADING, self)
	self.tLayerList[const.LAYER_CLICKEFF] = clsGameLayer.new(const.LAYER_CLICKEFF, self)
	self.tLayerList[const.LAYER_WAITING] = clsGameLayer.new(const.LAYER_WAITING, self)
	self.tLayerList[const.LAYER_TOPEST] = clsGameLayer.new(const.LAYER_TOPEST, self)
end
