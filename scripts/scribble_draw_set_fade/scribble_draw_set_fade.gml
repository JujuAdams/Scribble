#macro SCRIBBLE_WARNING_DRAW_SET_FADE_DEPRECATED  true
if (SCRIBBLE_WARNING_DRAW_SET_FADE_DEPRECATED)
{
    show_error("Scribble:\nscribble_draw_set_fade() will be deprecated in v6.0.0\nPlease convert your code to use the autotype functions\n \n(Set SCRIBBLE_WARNING_DRAW_SET_FADE_DEPRECATED to <false> to hide this warning)\n ", true);
    exit;
}

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