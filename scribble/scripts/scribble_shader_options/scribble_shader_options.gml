/// @param wave_size
/// @param shake_size
/// @param rainbow

var _wave    = argument0;
var _shake   = argument1;
var _rainbow = argument2;

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_vOptions" ), _wave, _shake, _rainbow );