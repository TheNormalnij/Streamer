
---@type integer[]
local TXD_LIST = {}
---@type boolean[]
local AVIALABLE_TXD = {}

local lastFreePos = 0

local function genValidTXDList()
    local engineGetModelTXDID = engineGetModelTXDID
    for _, list in pairs{ ID_LIST_ATOMIC, ID_LIST_CLUMP, ID_LIST_TIMED } do
        for _, modelId in pairs(list) do
            AVIALABLE_TXD[engineGetModelTXDID(modelId)] = true;
        end
    end

    for modelId in pairs(AVIALABLE_TXD) do
        table.insert(TXD_LIST, modelId)
    end

    lastFreePos = #TXD_LIST
end

---@return integer
function getFreeTxdID()
    if lastFreePos == 0 then
        error("Can not return free TXD", 2)
    end
    local id = TXD_LIST[lastFreePos]
    lastFreePos = lastFreePos - 1
    return id
end

---@param txdId integer
function restoreTxdId( txdId )
    if AVIALABLE_TXD[txdId] == false then
        table.insert( TXD_LIST, txdId )
        lastFreePos = lastFreePos + 1

        AVIALABLE_TXD[txdId] = true
    end
end

genValidTXDList()
