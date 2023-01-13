/// @param name

function scribble_font_exists(_name)
{
    return ds_map_exists(__scribble_get_font_data_map(), _name);
}
