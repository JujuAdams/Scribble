/// @param sprite_slot_array

var _array = argument0;

shader_set_uniform_f_array( shader_get_uniform( shader_current(), "u_fSpriteImage" ), _array );