/// Sets the various properties of Scribble's dynamic rendering
/// 
/// @param waveSize         Maximum pixel offset of the [wave] effect                                                                                
/// @param waveFrequency    Frequency of the [wave] effect. Larger values will create more horizontally frequent "humps" in the text                 
/// @param waveSpeed        Speed of the [wave] effect                                                                           
/// @param shakeSize        Maximum pixel offset of the [shake] effect                                                                               
/// @param shakeSpeed       Speed of the [shake] effect. Larger numbers cause text to shake faster                                                   
/// @param rainbowWeight    Blend weight of the [rainbow] effect. A value of 0 will not apply the effect, a value of 1 will blend with 100% weighting
/// @param rainbowSpeed     Cycling speed of the [rainbow] effect. Increase to make colour scrolling faster                                            
/// @param wobbleAngle      Maximum angular offset of the [wobble] effect                                                   
/// @param wobbleFrequency  Speed of the [wobble] effect. Larger numbers cause text to oscillate faster                                              
/// @param pulseScale       Maximum scale of the [pulse] effect                                                                      
/// @param pulseSpeed       Speed of the [pulse] effect. Larger values will cause text to shrink and grow faster   
/// @param wheelSize        Maximum pixel offset of the [wheel] effect                                                                                
/// @param wheelFrequency   Frequency of the [wheel] effect. Larger values will create more chaotic motion            
/// @param wheelSpeed       Speed of the [wheel] effect                                      
/// 
/// Find out more about what animation effects are available on the wiki: https://github.com/JujuAdams/scribble/wiki/(5.5.0)-Text-Formatting
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