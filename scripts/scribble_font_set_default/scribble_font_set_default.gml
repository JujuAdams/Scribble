/// Sets the default font to use for Scribble text elements
/// 
/// @param fontName   The name of the default Scribble font to use, as a string

function scribble_font_set_default(_font)
{
    //Check if the default font parameter is the correct datatype
    if (!is_string(_font))
    {
        show_error("Scribble:\nThe default font should be defined using its name as a string.\n(Input was an invalid datatype)\n ", false);
        return undefined;
    }
    
    if (SCRIBBLE_VERBOSE && (global.__scribble_default_font == undefined))
    {
        __scribble_trace("Setting default font to \"" + string(_font) + "\"");
    }
    
    global.__scribble_default_font = _font;
}