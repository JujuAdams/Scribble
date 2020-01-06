/// Sets the various properties of Scribble's dynamic rendering.
/// 
/// @param waveSize         The maximum pixel offset of the [wave] effect.
/// @param waveFrequency    The frequency of the [wave] effect. Larger values will create more horizontally frequent "humps" in the text.
/// @param waveSpeed        The speed of the [wave] effect.
/// @param shakeSize        The maximum pixel offset of the [shake] effect.
/// @param shakeSpeed       The speed of the [shake] effect. Increase to make shaking faster.
/// @param rainbowWeight    The blend weight of the [rainbow] effect. A value of 0 will not apply the effect, a value of 1 will blend with 100% weighting.
/// @param rainbowSpeed     Cycling speed of the [rainbow] effect. Increase to make colour scrolling faster.
/// @param wobbleAngle      
/// @param wobbleFrequency  
/// @param pulseScale
/// @param pulseSpeed
/// 
/// This script "sets state". All text drawn with scribble_draw() will use these settings until they're overwritten,
/// either by calling this script again or by calling scribble_draw_reset() / scribble_draw_set_state().

var _count = argument_count;
if (_count > SCRIBBLE_MAX_DATA_FIELDS)
{
    show_error("Scribble:\nscribble_set_animation() given " + string(_count) + " parameters but was expecting " + string(SCRIBBLE_MAX_DATA_FIELDS) + "\n ", false);
    return false;
}

var _i = 0;
repeat(_count)
{
    if (argument[_i] != undefined) global.scribble_state_anim_array[@ _i] = argument[_i];
    ++_i;
}

return true;