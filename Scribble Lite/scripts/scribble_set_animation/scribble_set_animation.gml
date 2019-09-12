/// @param waveSize
/// @param waveFrequency
/// @param waveSpeed
/// @param shakeSize
/// @param shakeSpeed
/// @param rainbowWeight
/// @param rainbowSpeed
/// @param ...

var _count = argument_count;
if (_count > SCRIBBLE_MAX_DATA_FIELDS)
{
    show_error("Scribble:\nscribble_set_animation() given " + string(_count) + " parameters but was expecting " + string(SCRIBBLE_MAX_DATA_FIELDS) + "\n ", false);
    return false;
}

var _i = 0;
repeat(_count)
{
    if (argument[_i] != undefined) global.__scribble_state_anim_array[@ _i] = argument[_i];
    ++_i;
}

return true;