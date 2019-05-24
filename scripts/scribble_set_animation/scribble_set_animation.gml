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

var _json = argument[0];

var _array = array_create(argument_count-1);
for(var _i = 1; _i < argument_count; _i++) _array[@ _i-1] = argument[_i];

if (is_array(_json)) _json[@ __SCRIBBLE.DATA_FIELDS ] = _array;

return _array;