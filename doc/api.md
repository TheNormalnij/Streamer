
# Shared

## registerWorld
```lua
nil registerWorld(worldInfo)
```

## getWorlds
```lua
table getWorlds()
```
Returns an array of all registered worlds. Every array entry contains fields:

- name string - World name
- imgs string[] - Path to used IMG's
- mapPath string - Path to map
- mapType "lua" - Map type
- resource resource - World resource
- resourceRoot Element - World resources root
- loader string - Loader type
