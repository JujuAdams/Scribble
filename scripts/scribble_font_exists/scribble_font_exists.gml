/// @param name

function scribble_font_exists(_name)
{
    static _font_data_map = __scribble_get_state().__font_data_map;
    return ds_map_exists(_font_data_map, _name);
}
