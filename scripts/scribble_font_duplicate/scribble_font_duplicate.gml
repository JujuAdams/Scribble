// Feather disable all
/// @param fontName
/// @param newName

function scribble_font_duplicate(_old, _new)
{
    var _oldFontData = __ScribbleGetFontData(_old);
    
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    if (ds_map_exists(_fontDataMap, _new)) __ScribbleError("Font \"", _new, "\" already exists");
    
    var _newFontData = new __ScribbleClassFont(_new, ds_grid_width(_oldFontData.__glyphDataGrid), _oldFontData.__renderType, false, _oldFontData.__texelsValid, 0, 0);
    _newFontData.__runtime = true;
    _oldFontData.__CopyTo(_newFontData, true);
}