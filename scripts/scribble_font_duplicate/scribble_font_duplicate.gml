/// @param fontName
/// @param newName

function scribble_font_duplicate(_old, _new)
{
    var _old_font_data = global.__scribble_font_data[? _old];
    var _new_font_data = new __scribble_class_font(_new, ds_grid_width(_old_font_data.__glyph_data_grid), _old_font_data.__msdf);
    _old_font_data.__copy_to(_new_font_data, true);
}