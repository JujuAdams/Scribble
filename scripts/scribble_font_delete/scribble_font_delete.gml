/// @param name

function scribble_font_delete(_name)
{
    var _font_data_map = __scribble_get_font_data_map();
    if (!ds_map_exists(_font_data_map, _name)) return;
    
    _font_data_map[? _name].__destroy();
    ds_map_delete(__scribble_get_font_data_map(), _name);
}
