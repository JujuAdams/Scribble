/// @param colour       The blend colour for the text. Defaults to draw_get_colour()
/// @param alpha        The alpha blend for the text. Defaults to draw_get_alpha()

var _colour = argument0;
var _alpha  = argument1;

global.__scribble_next_blend_instance = id;
global.__scribble_next_blend_time     = get_timer();
global.__scribble_next_blend_colour   = _colour;
global.__scribble_next_blend_alpha    = _alpha;