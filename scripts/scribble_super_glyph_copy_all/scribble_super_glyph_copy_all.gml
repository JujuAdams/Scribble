// Feather disable all
/// @param targetFontName
/// @param sourceFontName
/// @param overwrite

function scribble_super_glyph_copy_all(_target, _source, _overwrite)
{
    var _targetFontData = __ScribbleGetFontData(_target);
    var _sourceFontData = __ScribbleGetFontData(_source);
    
    var _sourceGlyphsMap      = _sourceFontData.__glyphsMap;
    var _sourceGlyphsDataGrid = _sourceFontData.__glyphDataGrid;
    var _targetGlyphsMap      = _targetFontData.__glyphsMap;
    var _targetGlyphsDataGrid = _targetFontData.__glyphDataGrid;
    
    var _keysArray = ds_map_keys_to_array(_sourceGlyphsMap);
    var _i = 0;
    repeat(array_length(_keysArray))
    {
        __ScribbleGlyphDuplicate(_sourceGlyphsMap, _sourceGlyphsDataGrid, _targetGlyphsMap, _targetGlyphsDataGrid, _keysArray[_i], _overwrite);
        ++_i;
    }
    
    //Choose maximal values
    _targetFontData.__height     = max(_targetFontData.__height,     _sourceFontData.__height);
    _targetFontData.__underlineY = max(_targetFontData.__underlineY, _sourceFontData.__underlineY);
    _targetFontData.__strikeY    = max(_targetFontData.__strikeY,    _sourceFontData.__strikeY);
    
    ds_grid_set_region(_targetGlyphsDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT, ds_grid_width(_targetGlyphsDataGrid), __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT, _targetFontData.__height);
}
