/// @description Sets a texel size vec2 uniform, from a surface, in the current shader
/// @param uniform
/// @param surface

if ( global.shader_focus == undefined ) exit;

var _texture = surface_get_texture( argument1 );
shader_set_uniform_f( shader_get_uniform( global.shader_focus, argument0 ), texture_get_texel_width( _texture ), texture_get_texel_height( _texture ) );