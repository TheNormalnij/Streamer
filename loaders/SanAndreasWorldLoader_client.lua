
---@class SanAndreasWorldLoader : ILoader, IWithDestructor
SanAndreasWorldLoader = class()

function SanAndreasWorldLoader:create()
end

function SanAndreasWorldLoader:destroy()

end

function SanAndreasWorldLoader:load()
    local restoreWorldModel = restoreWorldModel
    for _, modelId in pairs(ID_PHYSICAL) do
        restoreWorldModel(modelId, 10000, 0, 0, 0)
    end

    restoreAllGameBuildings()
    setOcclusionsEnabled( true )
    resetWaterLevel()

    return true
end

function SanAndreasWorldLoader:unload()
    -- Remove dummies
    local removeWorldModel = removeWorldModel
    for _, modelId in pairs(ID_PHYSICAL) do
        removeWorldModel(modelId, 10000, 0, 0, 0)
    end

    removeAllGameBuildings()
    setOcclusionsEnabled( false )
    setWaterLevel( -5000, true, true, true, false )

    return true
end
