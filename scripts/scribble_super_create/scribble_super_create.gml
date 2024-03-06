// Feather disable all
/// @param newFontName

function scribble_super_create(_name)
{
    //Ensure we're initialised
    __scribble_initialize();
    
    var _font_data = new __scribble_class_font(_name, 1, undefined);
    _font_data.__runtime   = true;
    _font_data.__superfont = true;
}
