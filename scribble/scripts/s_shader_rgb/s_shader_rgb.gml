/// @description Sets a colour vec3 uniform in the current shader
/// @param uniform
/// @param colour

if ( global.shader_focus == undefined ) exit;

shader_set_uniform_f( shader_get_uniform( global.shader_focus, argument0 ), colour_get_red(argument1)/255, colour_get_green(argument1)/255, colour_get_blue(argument1)/255 );