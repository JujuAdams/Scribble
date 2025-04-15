// Feather disable all

/// Removes a font that was added using `scribble_external_font_add()`.
/// 
/// N.B. Removing a font with this function will trigger a refreshing of all text elements. This
///      carries a performance penalty. As a result, you should not call this function often.
/// 
/// @param fontName

function scribble_external_font_remove(_font_name)
{
    static _font_data_map = __scribble_initialize().__font_data_map;
    
    if (not ds_map_exists(_font_data_map, _font_name))
    {
        __scribble_trace($"Warning! Font \"{_font_name}\" has already been removed");
        return;
    }
    
    var _font_data = _font_data_map[? _font_name];
    
    if (_font_data.__from_bundle)
    {
        __scribble_error($"Cannot remove font \"{_font_name}\"\nIt was not added using `scribble_external_font_add()`");
        return;
    }
    
    _font_data.__destroy();
    scribble_refresh_everything();
}