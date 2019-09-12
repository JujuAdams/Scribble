/// Sets Scribble's typewriter fade in/out state.
/// 
/// 
/// @param fadeIn       Whether to fade in or out (boolean)
/// @param position     The position of the typewriter animation.
/// @param method       The typewriter method to use. See below for more details.
/// @param smoothness   The smoothness of the typewriter fade effect (not used for SCRIBBLE_TYPEWRITER_WHOLE). A value of "0" disables smooth fading.
/// 
/// 
/// Scribble supports three fade effects, collectively called "typewriter" effects.
/// SCRIBBLE_TYPEWRITER_PER_CHARACTER: Fade each character individually
/// SCRIBBLE_TYPEWRITER_WHOLE:         Fade the entire textbox in and out
/// SCRIBBLE_TYPEWRITER_PER_LINE:      Fade each line of text as a group

global.scribble_state_tw_fade_in    = argument0;
global.scribble_state_tw_position   = argument1;
global.scribble_state_tw_method     = argument2;
global.scribble_state_tw_smoothness = argument3;

if ((global.scribble_state_tw_method != SCRIBBLE_TYPEWRITER_WHOLE)
&&  (global.scribble_state_tw_method != SCRIBBLE_TYPEWRITER_PER_CHARACTER)
&&  (global.scribble_state_tw_method != SCRIBBLE_TYPEWRITER_PER_LINE))
{
    show_error("Scribble:\nTypewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_WHOLE, SCRIBBLE_TYPEWRITER_PER_CHARACTER, or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false);
}