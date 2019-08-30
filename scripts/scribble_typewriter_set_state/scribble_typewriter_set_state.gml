/// Begins a fade-in animation for a Scribble data structure, starting at 0% visible
///
/// A Scribble typewriter state is a decimal value from 0 to 2 (inclusive).
///
///     State = 0  : Text not yet faded in, invisible
/// 0 < State < 1  : Text is fading in
///     State = 1  : Text fully visible
/// 1 < State < 2  : Text is fading out
///     State = 2  : Text fully faded out, invisible
///
/// @param json    The Scribble data structure to target
/// @param state

var _json  = argument0;
var _state = clamp(argument1, 0, 2);

if (!is_real(_json) || !ds_exists(_json, ds_type_list))
{
    show_error("Scribble:\nScribble data structure \"" + string( _json ) + "\" doesn't exist!\n ", false);
    exit;
}

if (_state >= 1)
{
    _state -=  1;
    var _direction = -1;
}
else
{
    var _direction = 1;
}

_json[| __SCRIBBLE.TW_DIRECTION] = _direction;

switch(_json[| __SCRIBBLE.TW_METHOD])
{
    case SCRIBBLE_TYPEWRITER_WHOLE:
        _json[| __SCRIBBLE.CHAR_FADE_T] = 1;
        _json[| __SCRIBBLE.LINE_FADE_T] = 1;
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        _json[| __SCRIBBLE.TW_POSITION] = _state*_json[| __SCRIBBLE.CHARACTERS];
        _json[| __SCRIBBLE.CHAR_FADE_T] = ((_direction < 0)? 1 : 0) + clamp(_state, 0, 1);
        _json[| __SCRIBBLE.LINE_FADE_T] = 1;
    break;
        
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        _json[| __SCRIBBLE.TW_POSITION] = _state*_json[| __SCRIBBLE.LINES];
        _json[| __SCRIBBLE.CHAR_FADE_T] = 1;
        _json[| __SCRIBBLE.LINE_FADE_T] = ((_direction < 0)? 1 : 0) + clamp(_state, 0, 1);
    break;
}