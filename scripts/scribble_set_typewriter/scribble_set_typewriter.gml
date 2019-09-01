/// @param fadeIn
/// @param speed
/// @param method
/// @param smoothness

global.__scribble_state_tw_fade_in    = argument0;
global.__scribble_state_tw_speed      = argument1;
global.__scribble_state_tw_method     = argument2;
global.__scribble_state_tw_smoothness = argument3;

if ((global.__scribble_state_tw_method != SCRIBBLE_TYPEWRITER_WHOLE)
&&  (global.__scribble_state_tw_method != SCRIBBLE_TYPEWRITER_PER_CHARACTER)
&&  (global.__scribble_state_tw_method != SCRIBBLE_TYPEWRITER_PER_LINE))
{
    show_error("Scribble:\nTypewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_WHOLE, SCRIBBLE_TYPEWRITER_PER_CHARACTER, or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false);
}