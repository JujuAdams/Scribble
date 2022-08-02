/// @param name

function scribble_font_exists(_name)
{
    return ds_map_exists(global.__scribble_font_data, _name);
}
