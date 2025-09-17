// Feather disable all

/// @param oldName
/// @param newName

function scribble_font_rename(_old, _new)
{
    var _data = __scribble_get_font_data(_old);
    
    static _fontDataMap = __scribble_system().__fontDataMap;
    _fontDataMap[? _new] = _data;
    ds_map_delete(_fontDataMap, _old);
    
    var _scribble_state = __scribble_system().__state;
    if (_scribble_state.__default_font == _old) _scribble_state.__default_font = _new;
}