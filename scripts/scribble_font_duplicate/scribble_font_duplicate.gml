// Feather disable all
/// @param fontName
/// @param newName

function scribble_font_duplicate(_old, _new)
{
    var _old_font_data = __ScribbleGetFontData(_old);
    
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    if (ds_map_exists(_fontDataMap, _new)) __ScribbleError("Font \"", _new, "\" already exists");
    
    var _newFontData = new __ScribbleClassFont(_new, ds_grid_width(_old_font_data.__glyphDataGrid), _old_font_data.__renderType, false, _old_font_data.__texelsValid);
    _newFontData.__runtime = true;
    _old_font_data.__CopyTo(_newFontData, true);
}