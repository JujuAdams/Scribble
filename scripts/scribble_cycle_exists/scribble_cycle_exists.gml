// Feather disable all

/// @param name

function scribble_cycle_exists(_name)
{
    static _cycle_data_map = __scribble_system().__cycle_data_map;
    
    return ds_map_exists(_cycle_data_map, _name);
}