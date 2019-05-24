/// @param json
/// @param waveSize
/// @param waveFrequency
/// @param waveSpeed
/// @param shakeSize
/// @param shakeSpeed
/// @param rainbowWeight
/// @param rainbowSpeed
/// @param wobbleAngle
/// @param wobbleFrequency
/// @param swellScale
/// @param swellSpeed
/// @param ...

var _json  = argument[0];
var _count = argument_count-1;

if (_count > SCRIBBLE_MAX_DATA_FIELDS)
{
    show_error("Scribble:\nscribble_set_animation() given " + string(_count) + " parameters but was expecting " + string(SCRIBBLE_MAX_DATA_FIELDS) + "\n ", false);
    exit;
}
else if (_count < SCRIBBLE_MAX_DATA_FIELDS)
{
    show_debug_message("Scribble: WARNING! Argument count (" + string(_count) + ") is less than expected " + string(SCRIBBLE_MAX_DATA_FIELDS));
}

var _array = array_create(SCRIBBLE_MAX_DATA_FIELDS, 0);
if (is_array(_json))
{
    _array = array_copy(_array, 0, _json[ __SCRIBBLE.DATA_FIELDS ], 0, SCRIBBLE_MAX_DATA_FIELDS);
}
else if (variable_global_exists("__scribble_default_animation_parameters"))
{
    _array = array_copy(_array, 0, global.__scribble_default_animation_parameters, 0, SCRIBBLE_MAX_DATA_FIELDS);
}

for(var _i = 1; _i < argument_count; _i++) if (argument[_i] != undefined) _array[@ _i-1] = argument[_i];

if (is_array(_json)) _json[@ __SCRIBBLE.DATA_FIELDS] = _array;

return _array;