
---@class StaticIMGModelLoader : Class, IWithDestructor
StaticIMGModelLoader = class()

function StaticIMGModelLoader:create( colmap, modelDefs, imgList )
    ---@private
    self.loadedImgs = {}
    ---@private
    self.colLoader = nil
    ---@private
    self.colmap = colmap
    ---@private
    ---@type IObjectDef[]
    self.modelDefs = modelDefs
    ---@private
    self.imgList = imgList
    ---@private
    ---@type number[]
    self.usedTXD = {}
end;

function StaticIMGModelLoader:destroy( )
    self:unload()
    safeDestroy(self.colLoader)
end;

function StaticIMGModelLoader:load( )
    self:loadIMGs()
    self:loadCOLs( self.colmap )
    self:loadModels( )
    engineRestreamWorld()
end;

function StaticIMGModelLoader:unload( )
    self:unloadModels()
    self:unloadIMGs()

    if self.colLoader then
        self.colLoader:unload()
    end

    engineRestreamWorld()
end;

function StaticIMGModelLoader:loadIMGs( )
    for i, imgPath in pairs(self.imgList) do
        local img = EngineIMG( imgPath )
        img:add()
        self.loadedImgs[i] = img
    end
end;

function StaticIMGModelLoader:unloadIMGs( )
    for i = #self.loadedImgs, 1, -1 do
        if self.loadedImgs[i] then
            self.loadedImgs[i]:destroy()
        end
    end
end;

---@private
---@param colmap IColDef[]
function StaticIMGModelLoader:loadCOLs( colmap )
    local firstImg = self.loadedImgs[1]
    if not firstImg then
        return
    end

    local files = firstImg:getFiles()
    if files[1] == 'allmapcolls.col' then
        self.colLoader = ColMapLoader()

        local content = firstImg:getFile( 0 )
        self.colLoader:load(content, colmap)
    end
end;

---@private
function StaticIMGModelLoader:loadModels( )
    local allocatedTxd = {}

    local img = self.loadedImgs[1]
    local cols = self.colLoader and self.colLoader:getCols() or {}

    local defs = self.modelDefs
    for _, def in pairs( defs ) do
        local modelId = getFreeModelId()
        def[1] = modelId

        if def[4] then
            engineReplaceCOL(cols[def[4]], modelId)
        end

        local txdId = allocatedTxd[ def[3] ]
        if not txdId then
            txdId = getFreeTxdID()
            table.insert(self.usedTXD, txdId)
            allocatedTxd[ def[3] ] = txdId

            img:linkTXD(def[3] - 1, txdId)
        end

        engineSetModelTXDID( modelId, txdId )

        img:linkDFF( def[2] - 1, modelId )

        engineSetModelFlags( modelId, def[6], true )
        engineSetModelLODDistance( modelId, def[5] )
    end
end;

---@private
function StaticIMGModelLoader:unloadModels()
    local txds = self.usedTXD
    for i = 1, #txds do
        restoreTxdId(txds[i])
    end

    local defs = self.modelDefs

    ---@type number
    local modelID
    for _, def in pairs( defs ) do
        modelID = def[1]
        engineResetModelTXDID(modelID)

        if def[4] then
            engineRestoreCOL(modelID)
        end

        engineResetModelFlags(modelID)
        engineResetModelLODDistance(modelID)
    end

end