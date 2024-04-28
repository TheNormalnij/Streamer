
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
    local def
    for i = 1, #waterData do
        def = waterData[i]
        if #def == 29 then
            loadedWater[i] = createWater( def[1], def[2], def[3], def[8], def[9], def[10], def[15], def[16], def[17], def[22], def[23], def[24], def[29] >= 2 )
        else
            loadedWater[i] = createWater( def[1], def[2], def[3], def[8], def[9], def[10], def[15], def[16], def[17], def[22] >= 2 )
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
