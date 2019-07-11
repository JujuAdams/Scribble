/// @param xscale         The horizontal scaling of the text. Defaults to the value set in __scribble_config()
/// @param yscale         The vertical scaling of the text. Defaults to the value set in __scribble_config()
/// @param angle          The rotation of the text. Defaults to the value set in __scribble_config()

var _xscale = argument0;
var _yscale = argument1;
var _angle  = argument2;

global.__scribble_next_trans_instance = id;
global.__scribble_next_trans_time     = get_timer();
global.__scribble_next_trans_xscale   = _xscale;
global.__scribble_next_trans_yscale   = _yscale;
global.__scribble_next_trans_angle    = _angle;