/// Sets Scribble's fade in/out state. This is a manual alternative to using the "autotype" feature.
/// N.B. Using this script will not trigger autotype events.
/// 
/// 
/// @param fadeIn       Whether to fade in or out (boolean).
/// @param position     The position of the fade effect. See below for more details.
/// @param method       The fade method to use. See below for more details.
/// @param smoothness   The smoothness of the fade effect. A value of "0" disables smooth fading.
/// 
/// 
/// Scribble supports two fade effects:
/// SCRIBBLE_TYPEWRITER_PER_CHARACTER: Fade each character individually. <position> is measured in "number of drawn characters"
/// SCRIBBLE_TYPEWRITER_PER_LINE:      Fade each line of text as a group. <position> is measured in "number of lines of text"
/// 
/// This script "sets state". All text drawn with scribble_draw() will use these settings until they're overwritten,
/// either by calling this script again or by calling scribble_draw_reset() / scribble_draw_set_state().

global.scribble_state_tw_fade_in    = argument0;
global.scribble_state_tw_position   = argument1;
global.scribble_state_tw_method     = argument2;
global.scribble_state_tw_smoothness = argument3;

if ((global.scribble_state_tw_method != SCRIBBLE_FADE_NONE)
&&  (global.scribble_state_tw_method != SCRIBBLE_FADE_PER_CHARACTER)
&&  (global.scribble_state_tw_method != SCRIBBLE_FADE_PER_LINE))
{
    show_error("Scribble:\nMethod not recognised.\nPlease use SCRIBBLE_FADE_NONE, SCRIBBLE_FADE_PER_CHARACTER, or SCRIBBLE_FADE_PER_LINE.\n ", false);
    global.scribble_state_tw_method = SCRIBBLE_FADE_NONE;
}