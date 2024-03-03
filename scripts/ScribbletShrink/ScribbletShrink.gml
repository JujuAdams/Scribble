// Feather disable all

/// Draws plain text without formatting. The text is shrunk down to within the given maximum width
/// and height using simple scaling. Text will appear immediately using GameMaker's native text
/// rendering. Over a few frames and in the background, Scribble will build a vertex buffer in the
/// background that replaces the native text rendering and is faster to draw.
/// 
/// This function scales text without adding newlines. If you want to scale down text whilst adding
/// newlines (a.k.a. "reflowing"), albeit at a performance penality, then use ScribbletFit().
/// 
/// N.B. Word breaks will only happen on spaces and any single words too long for a line will not
///      be split in the middle. Per-character text wrapping (commonly used for Chinese) is not
///      supported.
/// 
/// This function relies on internal caching for performance gains. If you change any of the
/// following arguments, Scribble will have to do extra work to recache the new text data. Try to
/// limit how often you change these variables to get the best performance.
///     - string
///     - hAlign
///     - vAlign
///     - font
///     - fontScale
///     - maxWidth
///     - maxHeight
/// 
/// @param string
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]
/// @param [width]
/// @param [height]

function ScribbletShrink(_string, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1, _maxWidth = infinity, _maxHeight = infinity)
{
    static _system      = __ScribbletSystem();
    static _nullWrapper = _system.__nullWrapper;
    static _cache       = _system.__wrappersCache;
    static _array       = _system.__elementsArray;
    
    if ((_string == "") || (_maxWidth < 0) || (_maxHeight < 0)) return _nullWrapper;
    if (_font == undefined) _font = _system.__defaultFont;
    
    var _key = string_concat(_string, ":",
                             _hAlign + 3*_vAlign, ":", //Pack these flags together
                             _font, ":",
                             _fontScale, ":",
                             _maxWidth, ":",
                             _maxHeight, ":C");
    
    var _wrapper = _cache[$ _key];
    if (_wrapper == undefined)
    {
        var _element = new __ScribbletClassShrink(_key, _string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight);
        var _wrapper = new __ScribbletClassWrapper(_element);
        _element.__wrapper = _wrapper;
        
        _cache[$ _key] = _wrapper;
        array_push(_array, _element);
    }
    
    return _wrapper;
}