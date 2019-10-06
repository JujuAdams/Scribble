/// @param textElement
/// @param method
/// @param speed
/// @param smoothness
/// @param fadeIn

var _scribble_array = argument0;
var _method         = argument1;
var _speed          = argument2;
var _smoothness     = argument3;
var _fade_in        = argument4;

if (_scribble_array[__SCRIBBLE.AUTOTYPE_FADE_IN] != _fade_in) _scribble_array[@ __SCRIBBLE.AUTOTYPE_POSITION] = 0;

_scribble_array[@ __SCRIBBLE.AUTOTYPE_METHOD    ] = _method;
_scribble_array[@ __SCRIBBLE.AUTOTYPE_SPEED     ] = _speed;
_scribble_array[@ __SCRIBBLE.AUTOTYPE_SMOOTHNESS] = _smoothness;
_scribble_array[@ __SCRIBBLE.AUTOTYPE_FADE_IN   ] = _fade_in;