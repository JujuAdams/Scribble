// Feather disable all

/// @param name
/// @param sprite
/// @param image
/// @param smooth

function scribble_cycle_add_from_sprite(_name, _sprite, _image, _smooth)
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
        __index:  _index,
        __data:   _sprite,
        __image:  _image,
        __smooth: _smooth,
    };
    
    surface_set_target(__scribble_ensure_cycle_surface());
    __scribble_cycle_draw(_name);
    surface_reset_target();
}