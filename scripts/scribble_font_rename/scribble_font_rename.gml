/// @param oldName
/// @param newName

function scribble_font_rename(_old, _new)
{
    var _data = __scribble_get_font_data(_old);
    
    static _font_data_map = __scribble_get_font_data_map();
    _font_data_map[? _new] = _data;
    ds_map_delete(_font_data_map, _old);
    
    if (global.__scribble_default_font == _old) global.__scribble_default_font = _new;
}