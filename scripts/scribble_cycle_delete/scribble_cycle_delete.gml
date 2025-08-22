// Feather disable all

/// @param name

function scribble_cycle_delete(_name)
{
    static _data_open_array = __scribble_system().__cycle_data_open_array;
    static _data_map        = __scribble_system().__cycle_data_map;
    
    if (ds_map_exists(_data_map, _name))
    {
        array_push(_data_open_array, _data_map[? _name].__index);
        ds_map_delete(_data_map, _name);
    }
}