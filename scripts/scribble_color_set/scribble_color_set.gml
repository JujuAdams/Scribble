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

function scribble_color_set(_name, _color)
{
    static _tagDict = __ScribbleSystem().__tagDict;
    
    if (_color == undefined)
    {
        __ScribbleRemoveTag(_name);
        return;
    }
    
    if (not is_numeric(_color))
    {
        __ScribbleError("Colour values should be 24-bit BGR values");
    }
    
    var _tagStruct = _tagDict[$ _name];
    if (is_struct(_tagStruct) && (_tagStruct.__type == __SCRIBBLE_TAG_COLOR))
    {
        if (_color != _tagStruct.__data.__color)
        {
            _tagStruct.__data.__color = _color;
            __ScribblePaletteReplaceIndex(_tagStruct.__data.__index, _color);
        }
    }
    else
    {
        var _index = __ScribblePaletteNewColor(_color);
        __ScribbleAddTag(_name, __SCRIBBLE_TAG_COLOR, { __color: _color, __index: _index }, false);
    }
}
