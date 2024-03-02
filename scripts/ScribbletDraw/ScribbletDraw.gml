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
///      You should use ScribbletDrawNative() instead if you plan for the drawn text to only show for
///      a few frames at a time.
/// 
/// @param x
/// @param y
/// @param string
/// @param [colour=white]
/// @param [alpha=1]
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]
/// @param [forceNative=false]

#macro __SCRIBBLET_GET  static _system = __ScribbletSystem();\
                        static _cache  = _system.__elementsCache;\
                        static _array  = _system.__elementsArray;\
                        ;\
                        if (_font == undefined) _font = _system.__defaultFont;\
                        var _key = string_concat(_string, ":",\
                                                 _hAlign + 3*_vAlign, ":",\ //Pack these flags together
                                                 _font, ":",\
                                                 _fontScale, ":A");\
                        ;\
                        var _struct = _cache[$ _key];\
                        if (_struct == undefined)\
                        {\
                            _struct = new __ScribbletClass(_key, _string, _hAlign, _vAlign, _font, _fontScale);\
                            _cache[$ _key] = _struct;\
                            array_push(_array, _struct);\
                        }\
                        ;\
                        _struct.__lastUse = current_time;

function ScribbletDraw(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1, _forceNative = SCRIBBLET_DEFAULT_FORCE_NATIVE)
{
    if (_string == "") return;
    __SCRIBBLET_GET
    _struct.__drawMethod(_x, _y, _colour, _alpha, _forceNative);
}