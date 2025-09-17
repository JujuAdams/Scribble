// Feather disable all

/// @param font
/// @param state

function scribble_font_force_bilinear_filtering(_font, _state)
{
    with(__ScribbleGetFontData(_font))
    {
        if (__bilinear == _state) return;
        __bilinear = _state;
        
        var _grid = __glyphDataGrid;
        var _i = 0;
        repeat(ds_grid_width(_grid))
        {
            var _material = _grid[# _i, __SCRIBBLE_GLYPH_PROPR_MATERIAL];
            var _newMaterial = _material.__DuplicateMaterialWithNewBilinear(_state);
            _grid[# _i, __SCRIBBLE_GLYPH_PROPR_MATERIAL] = _newMaterial;
            
            ++_i;
        }
    }
}
