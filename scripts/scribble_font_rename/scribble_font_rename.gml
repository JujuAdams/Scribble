/// @param oldName
/// @param newName

function scribble_font_rename(_old, _new)
{
    if (!ds_map_exists(global.__scribble_font_data, _old))
    {
        __scribble_error("Font \"", _old, "\" doesn't exist");
        return;
    }
    
    if (ds_map_exists(global.__scribble_font_data, _new))
    {
        __scribble_error("Font \"", _new, "\" already exists");
        return;
    }
    
    var _data = global.__scribble_font_data[? _old];
    
    global.__scribble_font_data[? _new] = _data;
    ds_map_delete(global.__scribble_font_data, _old);
    
    if (global.__scribble_default_font == _old) global.__scribble_default_font = _new;
}