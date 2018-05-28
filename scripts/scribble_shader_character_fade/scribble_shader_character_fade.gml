/// @param char_fade_t
/// @param char_fade_smoothness

var _char_t          = argument0;
var _char_smoothness = argument1;

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fCharFadeT"          ), _char_t / ( 1 - _char_smoothness ) );
shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fCharFadeSmoothness" ), _char_smoothness );