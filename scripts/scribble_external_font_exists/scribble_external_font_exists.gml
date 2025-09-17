// Feather disable all

/// Returns if a font with the specified name exists and has been added as an external font using
/// `scribble_external_font_add()`. This function will return `false` if a font exists but was
/// *not* created by calling `scribble_external_font_add()`.
/// 
/// @param fontName

function scribble_external_font_exists(_font_name)
{
    static _fontDataMap = __scribble_system().__fontDataMap;
    
    if (not ds_map_exists(_fontDataMap, _font_name))
    {
        return false;
    }
    
    var _font_data = _fontDataMap[? _font_name];
    
    if (_font_data.__fromBundle)
    {
        return false;
    }
    
    return true;
}