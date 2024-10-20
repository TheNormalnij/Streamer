
-- For models

---@type IdManager
AtomicSAModelManager = IdManager(ID_LIST_ATOMIC, 'atomic sa')
---@type IdManager
TimedSAModelManager = IdManager(ID_LIST_TIMED, 'timed sa')
---@type IdManager
ClumpSAModelManager = IdManager(ID_LIST_CLUMP, 'clump sa')

---@type DynamicModelIdManager
AtomicDynamicModelManager = DynamicModelIdManager('object')

---@type DynamicModelIdManager
TimedDynamicModelManager = DynamicModelIdManager('timed-object')

---@type DynamicModelIdManager
ClumpDynamicModelManager = DynamicModelIdManager('clump')

---@type DynamicModelIdManager
DamageableDynamicModelManager = DynamicModelIdManager('damageable-object')

---@type MixedModelIdManager
AtomicMixedModelManager = MixedModelIdManager(AtomicSAModelManager, AtomicDynamicModelManager)
---@type MixedModelIdManager
TimedMixedModelManager = MixedModelIdManager(TimedSAModelManager, TimedDynamicModelManager)
---@type MixedModelIdManager
ClumpMixedModelManager = MixedModelIdManager(ClumpSAModelManager, ClumpDynamicModelManager)

-- For TXD

---@return number[]
local function genValidTXDList()
    ---@type table<number, true>
    local avialableTxdSet = {}
    local engineGetModelTXDID = engineGetModelTXDID
    for _, list in pairs{ ID_LIST_ATOMIC, ID_LIST_CLUMP, ID_LIST_TIMED } do
        for _, modelId in pairs(list) do
            avialableTxdSet[engineGetModelTXDID(modelId)] = true;
        end
    end

    local avialableTxdArray = {}
    for modelId in pairs(avialableTxdSet) do
        table.insert(avialableTxdArray, modelId)
    end

    return avialableTxdArray
end

---@type IdManager
TxdSAModelManager = IdManager(genValidTXDList(), 'txd sa')
