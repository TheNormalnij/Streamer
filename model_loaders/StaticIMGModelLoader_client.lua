
---@class StaticIMGModelLoader : Class, IWithDestructor
---@field private loadedImgs IMG[]
---@field private colLoader ColMapLoader
---@field private colmap table<number, { [1]: number, [2]: number }>
---@field private defsMap IDefsMap
---@field private modelDefs number[][]
---@field private imgList string[]
---@field private usedTXD number[]
---@field private oldVisibleTime table<number, { [1]: number, [2]: number }>
---@field private loaded boolean
StaticIMGModelLoader = class()
function StaticIMGModelLoader:create( colmap, modelDefs, defsMap, imgList )
    self.loadedImgs = {}
    self.colLoader = nil
    self.colmap = colmap
    self.modelDefs = modelDefs
    self.defsMap = defsMap
    self.imgList = imgList
    self.usedTXD = {}
    self.oldVisibleTime = {}
    self.loaded = false
end;

function StaticIMGModelLoader:destroy( )
    if self.loaded then
        self:unload()
    end
    safeDestroy(self.colLoader)
end;

function StaticIMGModelLoader:load( )
    self:loadIMGs()
    self:loadCOLs( self.colmap )
    self:loadModels( )
    engineRestreamWorld(true)
    self.loaded = true
end;

function StaticIMGModelLoader:unload( )
    self:unloadModels()
    self:unloadIMGs()

    if self.colLoader then
        self.colLoader:unload()
    end

    engineRestreamWorld(true)
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

    local engineReplaceCOL = engineReplaceCOL
    local engineSetModelTXDID = engineSetModelTXDID
    local engineSetModelFlags = engineSetModelFlags
    local engineSetModelLODDistance = engineSetModelLODDistance
    local engineImageLinkTXD = engineImageLinkTXD
    local engineImageLinkDFF = engineImageLinkDFF


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

            engineImageLinkTXD(img, def[3], txdId)
        end

        engineSetModelTXDID( modelId, txdId )

        engineImageLinkDFF(img, def[2], modelId)

        engineSetModelFlags( modelId, def[6], true )
        engineSetModelLODDistance( modelId, def[5], true )
    end

    local defs = self.modelDefs
    getFreeModelId = AtomicMixedModelManager.getFreeID
    for i = 1, self.defsMap.atomic do
        loadAtomicModel(defs[i])
    end

    local oldVisibleTime = self.oldVisibleTime
    local engineSetModelVisibleTime = engineSetModelVisibleTime
    local engineGetModelVisibleTime = engineGetModelVisibleTime

    getFreeModelId = TimedMixedModelManager.getFreeID
    for i = self.defsMap.atomic + 1, self.defsMap.timed do
        local def = defs[i]
        loadAtomicModel(def)
        oldVisibleTime[def[1]] = { engineGetModelVisibleTime(def[1]) }
        engineSetModelVisibleTime(def[1], def[7], def[8])
    end

    getFreeModelId = ClumpMixedModelManager.getFreeID
    for i = self.defsMap.timed + 1, self.defsMap.clump do
        loadAtomicModel(defs[i])
    end

    getFreeModelId = DamageableDynamicModelManager.getFreeID
    for i = self.defsMap.clump + 1, self.defsMap.timed do
        loadAtomicModel(defs[i])
    end
end;

---@private
function StaticIMGModelLoader:unloadModels()
    local restoreTxdId = TxdSAModelManager.restoreID
    local txds = self.usedTXD
    for i = 1, #txds do
        restoreTxdId(txds[i])
    end

    local engineResetModelTXDID = engineResetModelTXDID
    local engineRestoreCOL = engineRestoreCOL
    local engineResetModelFlags = engineResetModelFlags
    local engineResetModelLODDistance = engineResetModelLODDistance
    local freeModel

    ---@param def IAtomicDefs
    local function unloadAtomic(def)
        local modelID = def[1]
        engineResetModelTXDID(modelID)

        if def[4] then
            engineRestoreCOL(modelID)
        end

        engineResetModelFlags(modelID)
        engineResetModelLODDistance(modelID)
        freeModel(modelID)
    end

    local defs = self.modelDefs

    freeModel = AtomicMixedModelManager.restoreID
    for i = 1, self.defsMap.atomic do
        unloadAtomic(defs[i])
    end

    local oldVisibleTime = self.oldVisibleTime
    local visibleTime

    freeModel = TimedMixedModelManager.restoreID
    local engineSetModelVisibleTime = engineSetModelVisibleTime
    for i = self.defsMap.atomic + 1, self.defsMap.timed do
        local def = defs[i]
        visibleTime = oldVisibleTime[def[1]]
        engineSetModelVisibleTime(def[1], visibleTime[1], visibleTime[2])
        unloadAtomic(def)
    end

    freeModel = ClumpMixedModelManager.restoreID
    for i = self.defsMap.timed + 1, self.defsMap.clump do
        unloadAtomic(defs[i])
    end

    freeModel = DamageableDynamicModelManager.restoreID
    for i = self.defsMap.clump + 1, self.defsMap.damageable do
        unloadAtomic(defs[i])
    end
end
