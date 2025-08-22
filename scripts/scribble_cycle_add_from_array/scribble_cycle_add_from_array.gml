// Feather disable all

/// @param name
/// @param rgbArray
/// @param [smooth=true]
/// @param [legacyBlend=false]

function scribble_cycle_add_from_array(_name, _rgbArray, _smooth = true, _legacyBlend = false)
{
    static _data_open_array = __scribble_system().__cycle_data_open_array;
    static _data_map        = __scribble_system().__cycle_data_map;
    
    if (ds_map_exists(_data_map, _name))
    {
        var _data = _data_map[? _name];
        var _index = _data.__index;
    }
    else
    {
        var _index = array_pop(_data_open_array);
        if (_index == undefined)
        {
            _index = ds_map_size(_data_map);
        }
    }
    
    _data_map[? _name] = {
        __index:       _index,
        __data:        _rgbArray,
        __image:       0,
        __smooth:      _smooth,
        __legacyBlend: _legacyBlend,
    };
    
    surface_set_target(__scribble_ensure_cycle_surface());
    __scribble_cycle_draw(_name);
    surface_reset_target();
}