// Feather disable all
/// @param fontName
/// @param newName

function scribble_font_duplicate(_old, _new)
{
    var _old_font_data = __scribble_get_font_data(_old);
    
    static _font_data_map = __scribble_initialize().__font_data_map;
    if (ds_map_exists(_font_data_map, _new)) __scribble_error("Font \"", _new, "\" already exists");
    
    var _new_font_data = new __scribble_class_font(_new, ds_grid_width(_old_font_data.__glyph_data_grid), _old_font_data.__fontType);
    _new_font_data.__runtime = true;
    _old_font_data.__copy_to(_new_font_data, true);
}
