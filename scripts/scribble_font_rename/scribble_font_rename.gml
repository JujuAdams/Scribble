// Feather disable all

/// @param oldName
/// @param newName

function scribble_font_rename(_old, _new)
{
    var _data = __ScribbleGetFontData(_old);
    
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    _fontDataMap[? _new] = _data;
    ds_map_delete(_fontDataMap, _old);
    
    var _scribbleState = __ScribbleSystem().__state;
    if (_scribbleState.__default_font == _old) _scribbleState.__default_font = _new;
}