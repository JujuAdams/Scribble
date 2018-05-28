/// @description Sets a sampler uniform, using a texture index, in the current shader
/// @param uniform
/// @param surface

if ( global.shader_focus == undefined ) exit;

texture_set_stage( shader_get_sampler_index( global.shader_focus, argument0 ), argument1 );