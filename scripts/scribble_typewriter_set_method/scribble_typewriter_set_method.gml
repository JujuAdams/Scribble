/// Three modes are supported:
/// 1) SCRIBBLE_TYPEWRITER_WHOLE         - Fades in the entire textbox at the same time
/// 2) SCRIBBLE_TYPEWRITER_PER_CHARACTER - Fades in the text one character at a time
/// 3) SCRIBBLE_TYPEWRITER_LINE          - Fades in the text one line at a time
///
/// @param scribbleArray   The Scribble data structure to target
/// @param method          The fade method to use. See description for more details. Defaults to "don't change this value"
/// @param smoothness      The smoothness of the fade in effect. Defaults to "don't change this value"
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _scribble_array = argument0;
var _method         = argument1;
var _smoothness     = argument2;

if (!scribble_exists(_scribble_array))
{
    show_error("Scribble:\nScribble data structure \"" + string(_scribble_array) + "\" doesn't exist!\n ", false);
    exit;
}

_scribble_array[@ __SCRIBBLE.TW_METHOD    ] = _method;
_scribble_array[@ __SCRIBBLE.TW_SMOOTHNESS] = _smoothness;

switch(_method)
{
    case SCRIBBLE_TYPEWRITER_WHOLE:
        _scribble_array[@ __SCRIBBLE.CHAR_FADE_T] = 1;
        _scribble_array[@ __SCRIBBLE.LINE_FADE_T] = 1;
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        _scribble_array[@ __SCRIBBLE.CHAR_FADE_T] = ((_scribble_array[__SCRIBBLE.TW_DIRECTION] < 0)? 1 : 0) + clamp(_scribble_array[__SCRIBBLE.TW_POSITION]/_scribble_array[__SCRIBBLE.CHARACTERS], 0, 1);
        _scribble_array[@ __SCRIBBLE.LINE_FADE_T] = 1;
    break;
        
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        _scribble_array[@ __SCRIBBLE.CHAR_FADE_T] = 1;
        _scribble_array[@ __SCRIBBLE.LINE_FADE_T] = ((_scribble_array[__SCRIBBLE.TW_DIRECTION] < 0)? 1 : 0) + clamp(_scribble_array[__SCRIBBLE.TW_POSITION]/_scribble_array[__SCRIBBLE.LINES], 0, 1);
    break;
}