// Feather disable all

/// Removes a font that was added using `scribble_external_font_add()`.
/// 
/// N.B. Removing a font with this function will trigger a refreshing of all text elements. This
///      carries a performance penalty. As a result, you should not call this function often.
/// 
/// @param fontName

function scribble_external_font_remove(_fontName)
{
    static _fontDataMap = __scribble_system().__fontDataMap;
    
    if (not ds_map_exists(_fontDataMap, _fontName))
    {
        __scribble_trace($"Warning! Font \"{_fontName}\" has already been removed");
        return;
    }
    
    var _font_data = _fontDataMap[? _fontName];
    
    if (_font_data.__fromBundle)
    {
        __scribble_error($"Cannot remove font \"{_fontName}\"\nIt was not added using `scribble_external_font_add()`");
        return;
    }
    
    _font_data.__Destroy();
    scribble_refresh_everything();
}