
# Shared

## registerWorld
Registers a world in the world manager. Use this function only in your world resources.

```lua
nil registerWorld(table worldInfo)
```

### Params
* table worldInfo - world information

### Required fields
- name string - World name
- imgs string[] - Path to used IMG's
- mapPath string - Path to map
- mapType "lua" - Map type

### Optional fields
- loader string - Loader type "SA" or "IMGStream" (default)

### Example

```lua
exports['Streamer']:registerWorld{
	name = 'UNI';
	imgs = { 'world1.img'; };
	mapPath = 'world.lua';
	mapType = 'lua';
}
```

## getWorlds

Returns an array of all registered worlds.

```lua
table getWorlds()
```

Returns an array with registered worlds. Every array element has fields:

- name string - World name
- imgs string[] - Path to used IMG's
- mapPath string - Path to map
- mapType "lua" - Map type
- resource resource - World resource
- resourceRoot Element - World resources root
- loader string - Loader type

### Example

```lua
function showAvialableWorlds()
    local worldNames = {}
    local worlds = exports['Streamer']:getWorlds()
    for key, worldInfo in ipairs(worlds) do
        worldNames[key] = worldInfo.name
    end

    outputChatBox("Avialable worlds: " .. table.concat(worldNames, ", "))
end
```
