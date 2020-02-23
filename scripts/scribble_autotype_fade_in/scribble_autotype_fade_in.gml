/// @param textElement
/// @param method
/// @param speed
/// @param smoothness

var _scribble_array = argument0;
var _method         = argument1;
var _speed          = argument2;
var _smoothness     = argument3;

//Check if this array is a relevant text element
if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
|| (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION)
|| _scribble_array[__SCRIBBLE.FREED])
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_autotype_fade_in() is not a valid Scribble text element.");
    exit;
}

if ((_method != SCRIBBLE_AUTOTYPE_NONE)
&&  (_method != SCRIBBLE_AUTOTYPE_PER_CHARACTER)
&&  (_method != SCRIBBLE_AUTOTYPE_PER_LINE)
&&  (_method != undefined))
{
    show_error("Scribble:\nMethod not recognised.\nPlease use SCRIBBLE_AUTOTYPE_NONE, SCRIBBLE_AUTOTYPE_PER_CHARACTER, or SCRIBBLE_AUTOTYPE_PER_LINE.\n ", false);
    _method = SCRIBBLE_AUTOTYPE_NONE;
}

//Update the remaining autotype state values
_scribble_array[@ __SCRIBBLE.AUTOTYPE_POSITION  ] = 0;
if (_method != undefined) _scribble_array[@ __SCRIBBLE.AUTOTYPE_METHOD] = _method;
_scribble_array[@ __SCRIBBLE.AUTOTYPE_SPEED     ] = _speed;
_scribble_array[@ __SCRIBBLE.AUTOTYPE_SMOOTHNESS] = _smoothness;
_scribble_array[@ __SCRIBBLE.AUTOTYPE_FADE_IN   ] = true;