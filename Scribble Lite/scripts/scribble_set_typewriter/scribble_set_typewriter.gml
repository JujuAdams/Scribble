/// Sets Scribble's typewriter fade in/out state.
/// 
/// 
/// @param fadeIn       Whether to fade in or out (boolean)
/// @param speed        The speed of the typewriter animation, in characters/lines per frame.
/// @param method       The typewriter method to use. See below for more details.
/// @param smoothness   The smoothness of the typewriter fade effect (not used for SCRIBBLE_TYPEWRITER_WHOLE). A value of "0" disables smooth fading.
/// 
/// Set any of these arguments to <undefined> to set as pass-through (usually inheriting SCRIBBLE_DEFAULT_BLEND_COLOUR and SCRIBBLE_DEFAULT_ALPHA).
/// 
/// 
/// Scribble supports three fade effects, collectively called "typewriter" effects.
/// SCRIBBLE_TYPEWRITER_PER_CHARACTER: Fade each character individually
/// SCRIBBLE_TYPEWRITER_WHOLE:         Fade the entire textbox in and out
/// SCRIBBLE_TYPEWRITER_PER_LINE:      Fade each line of text as a group

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