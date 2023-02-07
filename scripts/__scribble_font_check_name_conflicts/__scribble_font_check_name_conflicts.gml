/// @param name

function __scribble_font_check_name_conflicts(_name)
{
    static _font_data_map           = __scribble_get_state().__font_data_map;
    static _font_original_name_dict = __scribble_get_state().__font_original_name_dict;
    
    if (ds_map_exists(_font_data_map, _name))
    {
        __scribble_trace("Warning! A font called \"", _name, "\" has already been added. Destroying the old font and creating a new one");
        _font_data_map[? _name].__destroy();
    }
    
    if (variable_struct_exists(_font_original_name_dict, _name))
    {
        __scribble_trace("Warning! A font originally named \"", _name, "\" has already been added. Destroying the old font and creating a new one");
        _font_original_name_dict[$ _name].__destroy();
    }
}