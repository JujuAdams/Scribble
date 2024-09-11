// Feather disable all
/// @param name

function scribble_font_exists(_name)
{
    static _font_data_map = __scribble_initialize().__font_data_map;
    return ds_map_exists(_font_data_map, _name);
}
