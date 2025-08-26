// Feather disable all

/// Adds a colour name for use with Scribble's text formatting tags
/// 
/// For example, adding a colour called "c_banana" will allow the use of the [c_banana] formatting
/// tag in text throughout your game
/// 
/// Setting a colour to <undefined> will delete the colour from Scribble
/// 
/// N.B. Changing colours with this function will trigger a refreshing of all text elements to keep
///      colours up to date. This carries a performance penalty. As a result, you should not change
///      colours frequently, and this function should typically be used at the start of the game or
///      on loading screens etc.
/// 
/// @param name
/// @param colour

function scribble_color_set(_name, _colour)
{
    if (_colour == undefined)
    {
        __scribble_remove_tag(_name);
        return;
    }
    
    if (not is_numeric(_colour))
    {
        __scribble_error("Colour values should be 24-bit BGR values");
    }
    
    __scribble_add_tag(_name, __SCRIBBLE_TAG_COLOR, _colour, false);
}
