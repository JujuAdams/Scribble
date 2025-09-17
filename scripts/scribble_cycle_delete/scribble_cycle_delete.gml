// Feather disable all

/// @param name

function scribble_cycle_delete(_name)
{
    static _data_open_array = __ScribbleSystem().__cycle_data_open_array;
    static _dataMap        = __ScribbleSystem().__cycleDataMap;
    
    if (ds_map_exists(_dataMap, _name))
    {
        array_push(_data_open_array, _dataMap[? _name].__index);
        ds_map_delete(_dataMap, _name);
    }
}