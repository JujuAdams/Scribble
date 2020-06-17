/// Creates a new font with an outline based on a given source font
///
/// @param sourceFontName   Name, as a string, of the font to use as a basis for the effect
/// @param newFontName      Name of the new font to create, as a strintg
/// @param thickness        Number of layers to use to generate the border. A value of 2 will give a 2px border
/// @param samples          Number of samples to use for the border per layer
/// @param color            Colour of the border
/// @param smooth           Whether or not to interpolate the border. Set to <false> for pixel fonts, set to <true> for anti-aliased fonts
function scribble_bake_outline(argument0, argument1, argument2, argument3, argument4, argument5) {

	var _source_font_name = argument0;
	var _new_font_name    = argument1;
	var _outline_size     = argument2;
	var _outline_samples  = argument3;
	var _outline_color    = argument4;
	var _smooth           = argument5;

	if (is_string(_outline_color))
	{
	    _outline_color = global.__scribble_colours[? _outline_color];
	    if (_outline_color == undefined)
	    {
	        show_error("Scribble:\nColour \"" + string(argument4) + "\" not recognised\n ", false);
	        exit;
	    }
	}

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



}
