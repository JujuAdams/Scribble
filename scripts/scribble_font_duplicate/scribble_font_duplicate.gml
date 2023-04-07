/// @param fontName
/// @param newName

function scribble_font_duplicate(_old, _new)
{
    var _old_font_data = __scribble_get_font_data(_old);
    
    static _font_data_map = __scribble_get_state().__font_data_map;
    if (ds_map_exists(_font_data_map, _new)) __scribble_error("Font \"", _new, "\" already exists");
    
    var _new_font_data = new __scribble_class_font(_new, _new, ds_grid_width(_old_font_data.__glyph_data_grid));
    _new_font_data.__type_runtime = true;
    _old_font_data.__copy_to(_new_font_data, true);
    
    //Set the bilinear filtering state for the font after we set other properties
    _new_font_data.__set_bilinear(undefined);
}