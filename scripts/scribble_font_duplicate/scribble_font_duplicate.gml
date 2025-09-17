// Feather disable all
/// @param fontName
/// @param newName

function scribble_font_duplicate(_old, _new)
{
    var _old_font_data = __scribble_get_font_data(_old);
    
    static _fontDataMap = __scribble_system().__fontDataMap;
    if (ds_map_exists(_fontDataMap, _new)) __scribble_error("Font \"", _new, "\" already exists");
    
    var _new_font_data = new __ScribbleClassFont(_new, ds_grid_width(_old_font_data.__glyphDataGrid), _old_font_data.__renderType, false, _old_font_data.__texelsValid);
    _new_font_data.__runtime = true;
    _old_font_data.__CopyTo(_new_font_data, true);
}