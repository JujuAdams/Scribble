// Feather disable all

/// @param font
/// @param state

function scribble_font_force_bilinear_filtering(_font, _state)
{
    with(__scribble_get_font_data(_font))
    {
        if (__bilinear == _state) return;
        __bilinear = _state;
        
        var _grid = __glyph_data_grid;
        var _i = 0;
        repeat(ds_grid_width(_grid))
        {
            var _material = _grid[# _i, SCRIBBLE_GLYPH.MATERIAL];
            var _new_material = _material.__duplicate_material_with_new_bilinear(_state);
            _grid[# _i, SCRIBBLE_GLYPH.MATERIAL] = _new_material;
            
            ++_i;
        }
    }
}
