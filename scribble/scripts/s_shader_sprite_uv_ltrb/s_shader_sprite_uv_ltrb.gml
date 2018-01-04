/// @description Sets a UV vec4 uniform containing the left-top-right-bottom coordinates, from a sprite, in the current shader
/// @param uniform
/// @param sprite
/// @param image

if ( global.shader_focus == undefined ) exit;

var _uvs = sprite_get_uvs( argument1, argument2 );
shader_set_uniform_f( shader_get_uniform( global.shader_focus, argument0 ), _uvs[0], _uvs[1], _uvs[6], _uvs[7] );