
---@class SanAndreasWorldLoader : ILoader, IWithDestructor
SanAndreasWorldLoader = class()

function SanAndreasWorldLoader:destroy()

end

function SanAndreasWorldLoader:load()
    restoreAllGameBuildings()
    setOcclusionsEnabled( true )
    resetWaterLevel()

    return true
end

function SanAndreasWorldLoader:unload()
    removeAllGameBuildings()
    setOcclusionsEnabled( false )
    setWaterLevel( -5000, true, true, true, false )

    return true
end
