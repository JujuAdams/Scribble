/// @param sourceFontName
/// @param newFontName
/// @param thickness
/// @param samples
/// @param color
/// @param smooth

var _source_font_name = argument0;
var _new_font_name    = argument1;
var _outline_size     = argument2;
var _outline_samples  = argument3;
var _outline_color    = argument4;
var _smooth           = argument5;

//Set our shader uniforms before use
shader_set(shd_scribble_bake_outline);
shader_set_uniform_i(shader_get_uniform(shader_current(), "u_iOutlineSize"), _outline_size);
shader_set_uniform_i(shader_get_uniform(shader_current(), "u_iOutlineSamples"), _outline_samples);
shader_set_uniform_f(shader_get_uniform(shader_current(), "u_vOutlineColor"), color_get_red(  _outline_color)/255,
	                                                                            color_get_green(_outline_color)/255,
	                                                                            color_get_blue( _outline_color)/255);
shader_reset();

//Run the baking operation
scribble_bake_shader(_source_font_name, _new_font_name, shd_scribble_bake_outline,
	                 2, _outline_size, _outline_size, _outline_size, _outline_size,
	                 _outline_size, _smooth);
