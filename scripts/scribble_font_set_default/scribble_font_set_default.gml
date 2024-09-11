// Feather disable all
/// Sets the default font to use for Scribble text elements
/// 
/// @param fontName   The name of the default Scribble font to use, as a string

function scribble_font_set_default(_font)
{
    //Check if the default font parameter is the correct datatype
    if (!is_string(_font))
    {
        __scribble_error("The default font should be defined using its name as a string.\n(Input was an invalid datatype)");
        return undefined;
    }
    
    static _scribble_state = __scribble_initialize().__state;
    if (SCRIBBLE_VERBOSE && (_scribble_state.__default_font == undefined)) __scribble_trace("Setting default font to \"" + string(_font) + "\"");
    _scribble_state.__default_font = _font;
}
