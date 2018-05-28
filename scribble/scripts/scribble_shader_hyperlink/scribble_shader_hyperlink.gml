/// @param hyperlink_colour
/// @param hyperlink_mix(array)

var _hyperlink_colour = argument0;
var _hyperlink_mix    = argument1;

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_vHyperlinkColour" ),
                      colour_get_red(   _hyperlink_colour )/255,
                      colour_get_green( _hyperlink_colour )/255,
                      colour_get_blue(  _hyperlink_colour )/255 );
shader_set_uniform_f_array( shader_get_uniform( shader_current(), "u_fHyperlinkMix" ), _hyperlink_mix );