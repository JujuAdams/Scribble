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
/// @param ...

var _json = argument[0];
var _count = argument_count-1;

if (_count > SCRIBBLE_MAX_DATA_FIELDS)
{
    show_error("Scribble:\nscribble_set_animation() given " + string(_count) + " parameters but was expecting " + string(SCRIBBLE_MAX_DATA_FIELDS) + "\n ", false);
    exit;
}

var _array = array_create(SCRIBBLE_MAX_DATA_FIELDS, 0);
for(var _i = 1; _i < argument_count; _i++) _array[@ _i-1] = argument[_i];

if (is_array(_json))
{
    _json[@ __SCRIBBLE.DATA_FIELDS ] = _array;
}
else
{
    global.__scribble_default_animation_parameters = _array;
    show_debug_message("Scribble: Set default animation parameters");
}