/// @param font
/// @param vertex_buffer
/// @param x
/// @param y

var _font  = argument0;
var _vbuff = argument1;
var _x     = argument2;
var _y     = argument3;

__scribble_submit_vertex_buffer( _vbuff, scribble_font_get_texture( _font ), _x, _y );