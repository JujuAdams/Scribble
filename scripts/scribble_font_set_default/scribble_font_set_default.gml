/// Prepares Scribble for use. This script should be called before any other Scribble scripts
/// 
/// @param fontName   The name of the default Scribble font to use, as a string

function scribble_font_set_default(_font)
{
    //Check if the default font parameter is the correct datatype
    if (!is_string(_font))
    {
        if (is_real(_font) && (asset_get_type(font_get_name(_font)) == asset_font))
        {
            show_error("Scribble:\nThe default font should be defined using its name as a string.\n(Input was \"" + string(_font) + "\", which might be font \"" + font_get_name(_font) + "\")\n ", false);
        }
        else
        {
            show_error("Scribble:\nThe default font should be defined using its name as a string.\n(Input was an invalid datatype)\n ", false);
        }
    
        _font = "";
    }
    else if ((asset_get_type(_font) != asset_font) && (asset_get_type(_font) != asset_sprite) && (_font != "")) //Check if the default font even exists!
    {
        show_error("Scribble:\nThe default font \"" + _font + "\" could not be found in the project.\n ", true);
        _font = "";
    }
    
    if (global.__scribble_default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_font) + "\"");
    }
    
    global.__scribble_default_font = _font;
}