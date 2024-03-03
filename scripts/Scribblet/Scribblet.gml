// Feather disable all

/// Draws plain text without formatting or layout. Text will appear immediately using GameMaker's
/// native text rendering. Over a few frames and in the background, Scribble will build a vertex
/// buffer in the background that replaces the native text rendering and is faster to draw.
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
/// N.B. This function should not be used for extremely fast changing text such as a stopwatch.
///      You should use ScribbletNative() instead if you plan for the drawn text to only show for
///      a few frames at a time.
/// 
/// @param string
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]

function Scribblet(_string, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1)
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
                             _fontScale, ":A");
    
    var _wrapper = _cache[$ _key];
    if (_wrapper == undefined)
    {
        var _element = new __ScribbletClass(_key, _string, _hAlign, _vAlign, _font, _fontScale);
        var _wrapper = new __ScribbletClassWrapper(_element);
        _element.__wrapper = _wrapper;
        
        _cache[$ _key] = _wrapper;
        array_push(_array, _element);
    }
    
    return _wrapper;
}