#macro SCRIBBLE_WARNING_DRAW_SET_BOX_ALIGN_DEPRECATED  true
if (SCRIBBLE_WARNING_DRAW_SET_BOX_ALIGN_DEPRECATED)
{
    show_error("Scribble:\nscribble_draw_set_box_align() will be deprecated in v6.0.0\nPlease convert your code to use the equivalent box_halign and box_valign functions\n \n(Set SCRIBBLE_WARNING_DRAW_SET_BOX_ALIGN_DEPRECATED to <false> to hide this warning)\n ", true);
    exit;
}

global.scribble_state_box_halign = argument0;
global.scribble_state_box_valign = argument1;