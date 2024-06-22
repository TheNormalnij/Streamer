
---@class SanAndreasWorldLoader : ILoader, IWithDestructor
---@field private loaded boolean
SanAndreasWorldLoader = class()

function SanAndreasWorldLoader:create()
    self.loaded = true
end

function SanAndreasWorldLoader:destroy()

end

function SanAndreasWorldLoader:load()
    if self.loaded then
        return true
    end

    local restoreWorldModel = restoreWorldModel
    for _, modelId in pairs(ID_PHYSICAL) do
        restoreWorldModel(modelId, 10000, 0, 0, 0)
    end

    restoreAllGameBuildings()
    setOcclusionsEnabled( true )
    resetWaterLevel()

    self.physicalBackup = {}
    self.loaded = true
    return true
end

function SanAndreasWorldLoader:unload()
    if not self.loaded then
        return
    end

    -- Remove dummies
    local removeWorldModel = removeWorldModel
    for _, modelId in pairs(ID_PHYSICAL) do
        removeWorldModel(modelId, 10000, 0, 0, 0)
    end

    removeAllGameBuildings()
    setOcclusionsEnabled( false )
    setWaterLevel( -5000, true, true, true, false )

    self.loaded = false
    return true
end
