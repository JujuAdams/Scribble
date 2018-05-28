/// @param line_fade_t
/// @param line_fade_smoothness

var _line_t          = argument0;
var _line_smoothness = argument1;

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fLineFadeT"          ), _line_t / ( 1 - _line_smoothness ) );
shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fLineFadeSmoothness" ), _line_smoothness );