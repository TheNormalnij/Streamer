
---@class SanAndreasWorldLoader : ILoader, IWithDestructor
SanAndreasWorldLoader = class()

function SanAndreasWorldLoader:create()
end

function SanAndreasWorldLoader:destroy()

end

function SanAndreasWorldLoader:load()
    restoreGameWorld()
    setOcclusionsEnabled( true )
    resetWaterLevel()

    return true
end

function SanAndreasWorldLoader:unload()
    removeGameWorld()
    setOcclusionsEnabled( false )
    setWaterLevel( -5000, true, true, true, false )

    return true
end
