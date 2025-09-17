// Feather disable all

/// @param name

function scribble_cycle_exists(_name)
{
    static _cycleDataMap = __ScribbleSystem().__cycleDataMap;
    
    return ds_map_exists(_cycleDataMap, _name);
}