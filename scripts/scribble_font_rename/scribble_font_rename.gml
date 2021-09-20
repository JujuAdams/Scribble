/// @param oldName
/// @param newName

function scribble_font_rename(_old, _new)
{
    var _data = global.__scribble_font_data[? _old];
    
    global.__scribble_font_data[? _new] = _data;
    ds_map_delete(global.__scribble_font_data, _old);
    
    if (global.__scribble_default_font == _old) global.__scribble_default_font = _new;
}