// Feather disable all
/// @param oldName
/// @param newName

function scribble_font_rename(_old, _new)
{
    var _data = __scribble_get_font_data(_old);
    
    var _grid = _data.__glyph_data_grid;
    ds_grid_set_region(_grid, 0, SCRIBBLE_GLYPH.FONT_NAME, ds_grid_width(_grid)-1, SCRIBBLE_GLYPH.FONT_NAME, _new);
        
    static _font_data_map = __scribble_initialize().__font_data_map;
    _font_data_map[? _new] = _data;
    ds_map_delete(_font_data_map, _old);
    
    var _scribble_state = __scribble_initialize().__state;
    if (_scribble_state.__default_font == _old) _scribble_state.__default_font = _new;
}
