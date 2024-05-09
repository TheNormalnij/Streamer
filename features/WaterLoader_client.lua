
---@alias IWaterData number[] 

---@class WaterLoader : Class, IWithDestructor
WaterLoader = class()

---@param waterData IWaterData
function WaterLoader:create( waterData )
    ---@private
    self.waterData = waterData
    ---@private
    self.loadedWater = {}
    ---@private
    self.loaded = false
end;

function WaterLoader:destroy( )
    if self.loaded then
        self:unload()
    end
end;

function WaterLoader:load( )
    if self.loaded then
        return false
    end
    local waterData = self.waterData
    local loadedWater = self.loadedWater
    local createWater = createWater
    local def
    for i = 1, #waterData do
        def = waterData[i]
        if #def == 29 then
            loadedWater[i] = createWater( def[1], def[2], def[3], def[4], def[5], def[6], def[7], def[8], def[9], def[10], def[11], def[12], def[13] )
        else
            loadedWater[i] = createWater( def[1], def[2], def[3], def[4], def[5], def[6], def[7], def[8], def[9], def[10] )
        end
    end

    self.loaded = true
end;

function WaterLoader:unload( )
    local loadedWater = self.loadedWater
    for i = #loadedWater, 1, -1 do
        if loadedWater[i] then
            destroyElement(loadedWater[i])
        end
        loadedWater[i] = nil
    end
    self.loaded = false
end;
