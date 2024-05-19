
local DAMAGE_EFFECT = {
    'none',
    'change_model',
    'smash',
    'change_smash',
    'breakable',
    'breakable_remove',
}

local COLLISION_RESPONSE = {
    'none',
    'lamppost',
    'small_box',
    'big_box',
    'fence_part',
    'grenade',
    'swingdoor',
    'lockdoor',
    'hanging',
    'poolball',
}

local FX_TYPE = {
    'none',
    'play_on_hit',
    'play_on_destroyed',
    'play_on_hitdestroyed',
}

local BREAK_MODE = {
    'not_by_gun',
    'by_gun',
    'smashable',
}

local FX_EFFECT = {
    'wallbust',
    'shootlight',
    'puke',
    'explosion_door',
    'explosion_crate',
    'explosion_barrel',
    'blood_heli',
    'tree_hit_palm',
    'tree_hit_fir',
    'water_swim',
    'water_splsh_sml',
    'water_splash_big',
    'water_splash',
    'water_hydrant',
    'tank_fire',
    'riot_smoke',
    'gunsmoke',
    'gunflash',
    'explosion_tiny',
    'explosion_small',
    'explosion_molotov',
    'explosion_medium',
    'explosion_large',
    'explosion_fuel_car',
    'exhale',
    'camflash',
    'prt_wake',
    false,
}

---@class IPhysicalData
---@field groups any[]
---@field models table<number, number[]> group id to model defs table
---@field defs number[][]

---@class PhysicalPropertiesLoader : Class, IWithDestructor
---@field private loaded boolean
PhysicalPropertiesLoader = class()

---@param physicalData IPhysicalData
---@param defs number[][]
function PhysicalPropertiesLoader:create( physicalData, defs )
    self.physicalData = physicalData
    self.defs = defs
    self.loaded = false
end;

function PhysicalPropertiesLoader:destroy( )
    if self.loaded then
        self:unload()
    end
end;

function PhysicalPropertiesLoader:load( )
    if self.loaded then
        return false
    end
    local engineSetObjectGroupPhysicalProperty = engineSetObjectGroupPhysicalProperty
    local engineSetModelPhysicalPropertiesGroup = engineSetModelPhysicalPropertiesGroup
    local allModels = self.physicalData.models
    local groups = self.physicalData.groups
    local defs = self.defs
    local group, models
    local groupId
    for i = 1, #groups do
        groupId = i - 1
        group = groups[i]

        engineSetObjectGroupPhysicalProperty(groupId, 'mass', group[1])
        engineSetObjectGroupPhysicalProperty(groupId, 'turn_mass', group[2])
        engineSetObjectGroupPhysicalProperty(groupId, 'air_resistance', group[3])
        engineSetObjectGroupPhysicalProperty(groupId, 'elasticity', group[4])
        engineSetObjectGroupPhysicalProperty(groupId, 'buoyancy', group[5])
        engineSetObjectGroupPhysicalProperty(groupId, 'uproot_limit', group[6])
        engineSetObjectGroupPhysicalProperty(groupId, 'col_damage_multiplier', group[7])
        engineSetObjectGroupPhysicalProperty(groupId, 'col_damage_effect', DAMAGE_EFFECT[ group[8] ])
        engineSetObjectGroupPhysicalProperty(groupId, 'special_col_response', COLLISION_RESPONSE[ group[9] ])
        engineSetObjectGroupPhysicalProperty(groupId, 'avoid_camera', group[10])
        engineSetObjectGroupPhysicalProperty(groupId, 'cause_explosion', group[11])
        engineSetObjectGroupPhysicalProperty(groupId, 'fx_type', FX_TYPE[ group[12] ])
        engineSetObjectGroupPhysicalProperty(groupId, 'fx_offset', group[13], group[14], group[15])
        engineSetObjectGroupPhysicalProperty(groupId, 'fx_system', FX_EFFECT[ group[16] ])
        engineSetObjectGroupPhysicalProperty(groupId, 'smash_multiplier', group[17])
        engineSetObjectGroupPhysicalProperty(groupId, 'break_velocity', group[18], group[19], group[20])
        engineSetObjectGroupPhysicalProperty(groupId, 'break_velocity_randomness', group[21])
        engineSetObjectGroupPhysicalProperty(groupId, 'break_mode', BREAK_MODE[ group[22] ])
        engineSetObjectGroupPhysicalProperty(groupId, 'sparks_on_impact', group[23])

        models = allModels[i]
        for j = 1, #models do
            engineSetModelPhysicalPropertiesGroup(defs[ models[j] ][1], groupId)
        end
    end

    self.loaded = true
end;

function PhysicalPropertiesLoader:unload( )
    local engineRestoreObjectGroupPhysicalProperties = engineRestoreObjectGroupPhysicalProperties
    local engineRestoreModelPhysicalPropertiesGroup = engineRestoreModelPhysicalPropertiesGroup

    local allModels = self.physicalData.models
    local defs = self.defs
    for i = 1, #self.physicalData.groups do
        groupId = i - 1
        engineRestoreObjectGroupPhysicalProperties(groupId)

        models = allModels[i]
        for j = 1, #models do
            engineRestoreModelPhysicalPropertiesGroup(defs[models[j]][1])
        end
    end

    self.loaded = false
end;
