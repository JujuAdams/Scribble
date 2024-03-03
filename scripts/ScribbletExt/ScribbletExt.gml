// Feather disable all

/// Draws plain text with limited formatting but without text wrapping. Text will appear
/// immediately using GameMaker's native text rendering. Over a few frames and in the
/// background, Scribble will build a vertex buffer in the background that replaces the native
/// text rendering and is faster to draw.
/// 
/// N.B. Manual line breaks ("newlines") are not supported.
/// 
/// This function relies on internal caching for performance gains. If you change any of the
/// following arguments, Scribble will have to do extra work to recache the new text data. Try to
/// limit how often you change these variables to get the best performance.
///     - string
///     - hAlign
///     - vAlign
///     - font
///     - fontScale
/// 
/// Two types of formatting command are supported:
/// 
/// 1. Partial Text Colouring
///     "This is [c_orange]orange[/c] text."
///     Tags that contain the name of a colour constant will colour subsequent characters in the
///     string. [/c] [/color] [/colour] can be used to reset the colour to the default colour for
///     the function call. New colours can be added with ScribbletAddColor(). Hash codes aren't
///     parsed automatically but hash codes can be added via ScribbletAddColor().
/// 
/// 2. In-line Sprites
///     "You need [sprCoin]100 to buy this bomb."
///     Sprites can be inserted by using the name of the sprite in between two square brackets.
///     Inserted sprites cannot be animated and show only one image at a time. By default, image 0
///     is shown.
///     
///     "You've found [sprFairy,0][sprFairy,1][sprFairy,2]"
///     By adding a second parameter to that tag, a different subimage in a sprite can be inserted.
///     
///     "Wow, magical! [sprSparke,0,0,4][sprSparke,0,0,0][sprSparke,0,0,-4]"
///     You may also specify a third and fourth parameter which acts as an x/y offset for the
///     sprite image. In this case, three images are displayed in a diagonal line from bottom to
///     top, going left to right. This feature is helpful for adjusting sprite positions to line
///     up better with text.
/// 
/// @param string
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]

function ScribbletExt(_string, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1)
{
    static _system      = __ScribbletSystem();
    static _nullWrapper = _system.__nullWrapper;
    static _cache       = _system.__wrappersCache;
    static _array       = _system.__elementsArray;
    
    if (_string == "") return _nullWrapper;
    if (_font == undefined) _font = _system.__defaultFont;
    
    var _key = string_concat(_string, ":",
                             _hAlign + 3*_vAlign, ":", //Pack these flags together
                             _font, ":",
                             _fontScale, ":D");
    
    var _wrapper = _cache[$ _key];
    if (_wrapper == undefined)
    {
        var _element = new __ScribbletClassExt(_key, _string, _hAlign, _vAlign, _font, _fontScale);
        var _wrapper = new __ScribbletClassWrapper(_element);
        _element.__wrapper = _wrapper;
        
        _cache[$ _key] = _wrapper;
        array_push(_array, _element);
    }
    
    return _wrapper;
}