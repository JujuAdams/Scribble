/// @description Sets a sampler uniform, using a sprite, in the current shader
/// @param uniform
/// @param sprite
/// @param image

if ( global.shader_focus == undefined ) exit;

texture_set_stage( shader_get_sampler_index( global.shader_focus, argument0 ), sprite_get_texture( argument1, argument2 ) );