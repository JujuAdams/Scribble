/// Creates a new font with an outline based on a given source font
///
/// @param sourceFontName   Name, as a string, of the font to use as a basis for the effect
/// @param newFontName      Name of the new font to create, as a strintg
/// @param thickness        Number of layers to use to generate the outline. A value of 2 will give a 2px outline
/// @param samples          Number of samples to use for the outline per layer
/// @param outlineColour    Colour of the outline
/// @param smooth           Whether or not to interpolate the outline. Set to <false> for pixel fonts, set to <true> for anti-aliased fonts

function scribble_font_bake_outline(_source_font_name, _new_font_name, _outline_size, _outline_samples, _outline_color, _smooth)
{
    if (is_string(_outline_color))
    {
        var _found = global.__scribble_colours[? _outline_color];
        if (_outline_color == undefined)
        {
            __scribble_error("Colour \"", _outline_color, "\" not recognised");
            exit;
        }
        _outline_color = _found & 0xFFFFFF;
    }

    //Set our shader uniforms before use
    shader_set(__shd_scribble_bake_outline);
    shader_set_uniform_i(shader_get_uniform(shader_current(), "u_iOutlineSize"), _outline_size);
    shader_set_uniform_i(shader_get_uniform(shader_current(), "u_iOutlineSamples"), _outline_samples);
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_vOutlineColor"), color_get_red(  _outline_color)/255,
                                                                                  color_get_green(_outline_color)/255,
                                                                                  color_get_blue( _outline_color)/255);
    shader_reset();

    //Run the baking operation
    scribble_font_bake_shader(_source_font_name, _new_font_name, __shd_scribble_bake_outline,
                              2, _outline_size, _outline_size, _outline_size, _outline_size,
                              _outline_size, _smooth);
}