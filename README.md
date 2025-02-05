# MTA Streamer - a world loader

This resource provide loader and API for big MTA maps.

### Features
- Effective map data structures.
- IMG streaming. You can save more RAM for your gamemode.
- Buildings API. Big maps doesn't cause FPS drops.
- LOD support.
- Damageable objects support.
- Physical objects support.

### Supported convertors
- [MtaWorldConvertingTools](https://github.com/TheNormalnij/MtaWorldConvertingTools)

# Usage

1. Convert a gta mod map with using [the converter](https://github.com/TheNormalnij/MtaWorldConvertingTools)
2. Copy the resulted resource into server resources folder
3. Start streamer and the resource
4. Load the world `/loadworld <world name>`

# Automatic world loading

1. Copy a world resource into server resources folder.
2. Open resources tab in your admin panel. Select `Streamer` and click settings.
3. Change `default_world` parameter to your world name.
4. Start `Streamer` and your world resource.

# Documentation
- [API](doc/api.md)
- [Settings](doc/settings.md)
