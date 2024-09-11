// Feather disable all
/// @param newFontName

function scribble_super_create(_name)
{
    var _font_data = new __scribble_class_font(_name, 1, undefined);
    _font_data.__runtime   = true;
    _font_data.__superfont = true;
}
