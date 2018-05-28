/// @param colour
/// @param mix

var _colour = argument0;
var _mix    = argument1;

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_vColour" ),
                      colour_get_red(   _colour )/255,
                      colour_get_green( _colour )/255,
                      colour_get_blue(  _colour )/255,
                      _mix );