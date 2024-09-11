// Feather disable all
/// @param name

function scribble_font_delete(_name)
{
    static _font_data_map = __scribble_initialize().__font_data_map;
    if (!ds_map_exists(_font_data_map, _name)) return;
    
    _font_data_map[? _name].__destroy();
    ds_map_delete(_font_data_map, _name);
}
