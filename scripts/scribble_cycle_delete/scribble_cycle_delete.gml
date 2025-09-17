// Feather disable all

/// @param name

function scribble_cycle_delete(_name)
{
    static _dataOpenArray = __ScribbleSystem().__cycleDataOpenArray;
    static _dataMap       = __ScribbleSystem().__cycleDataMap;
    
    if (ds_map_exists(_dataMap, _name))
    {
        array_push(_dataOpenArray, _dataMap[? _name].__index);
        ds_map_delete(_dataMap, _name);
    }
}