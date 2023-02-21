/// Adds a colour name for use with Scribble's text formatting tags
/// 
/// For example, adding a colour called "banana" will allow the use of the [banana] formatting
/// tag in text throughout your game
/// 
/// N.B. Changing colour formatting tags will trigger a refreshing of all text elements to keep
///      colours up to date. This carries a performance penalty. As a result, you should not
///      change colours frequently and this function should typically be used at the start of
///      the game or on loading screens etc.
/// 
/// @param name
/// @param colour

function scribble_color_set(_name, _colour)
{
    static _colourDict = __scribble_config_colours();
    if (_colourDict[$ _name] != _colour)
    {
        _colourDict[$ _name] = _colour;
        
        //Ensure that any custom colours that are in text elements are updated
        scribble_refresh_everything();
    }
}