
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
    ---@type IDefs
    self.modelDefs = modelDefs
    ---@private
    self.imgList = imgList
    ---@private
    ---@type number[]
    self.usedTXD = {}
    ---@private
    ---@type table<number, { [1]: number, [2]: number }>
    self.oldVisibleTime = {}
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

    local getFreeTxdID = TxdSAModelManager.getFreeID
    local getFreeModelId

    ---@param def IAtomicDefs
    local function loadAtomicModel(def)
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

    local defsByType = self.modelDefs
    for _, def in pairs( defsByType.atomic ) do
        getFreeModelId = AtomicMixedModelManager.getFreeID
        loadAtomicModel(def)
    end

    for _, def in pairs( defsByType.clump ) do
        getFreeModelId = ClumpMixedModelManager.getFreeID
        loadAtomicModel(def)
    end

    local oldVisibleTime = self.oldVisibleTime
    local engineSetModelVisibleTime = engineSetModelVisibleTime
    local engineGetModelVisibleTime = engineGetModelVisibleTime

    for _, def in pairs( defsByType.timed ) do
        getFreeModelId = TimedMixedModelManager.getFreeID
        loadAtomicModel(def)
        oldVisibleTime[ def[1] ] = { engineGetModelVisibleTime(def[1]) }
        engineSetModelVisibleTime(def[1], def[7], def[8])
    end
end;

---@private
function StaticIMGModelLoader:unloadModels()
    local restoreTxdId = TxdSAModelManager.restoreID
    local txds = self.usedTXD
    for i = 1, #txds do
        restoreTxdId(txds[i])
    end

    local defs = self.modelDefs

    local engineResetModelTXDID = engineResetModelTXDID
    local engineRestoreCOL = engineRestoreCOL
    local engineResetModelFlags = engineResetModelFlags
    local engineResetModelLODDistance = engineResetModelLODDistance

    ---@param def IAtomicDefs
    local function unloadAtomic(def)
        local modelID = def[1]
        engineResetModelTXDID(modelID)

        if def[4] then
            engineRestoreCOL(modelID)
        end

        engineResetModelFlags(modelID)
        engineResetModelLODDistance(modelID)
    end

    for _, def in pairs( defs.atomic ) do
        unloadAtomic(def)
    end

    for _, def in pairs( defs.clump ) do
        unloadAtomic(def)
    end

    local oldVisibleTime = self.oldVisibleTime
    local visibleTime

    local engineSetModelVisibleTime = engineSetModelVisibleTime
    for _, def in pairs( defs.timed ) do
        unloadAtomic(def)
        visibleTime = oldVisibleTime[def[1]]
        engineSetModelVisibleTime(def[1], visibleTime[7], visibleTime[8])
    end
end
