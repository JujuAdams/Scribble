// Feather disable all
/// Creates a new font with an outline based on a given source font
///
/// @param sourceFontName   Name, as a string, of the font to use as a basis for the effect
/// @param newFontName      Name of the new font to create, as a strintg
/// @param outlineColour    Colour of the outline
/// @param smooth           Whether or not to interpolate the outline. Set to <false> for pixel fonts, set to <true> for anti-aliased fonts
/// @param [textureSize]

function scribble_font_bake_outline_8dir(_source_font_name, _new_font_name, _outline_color, _smooth, _textureSize = undefined)
{
    if (is_string(_outline_color))
    {
        var _colors_struct = __scribble_config_colours();
        
        var _found = _colors_struct[$ _outline_color];
        if (_outline_color == undefined)
        {
            __scribble_error("Colour \"", _outline_color, "\" not recognised");
            exit;
        }
        
        _outline_color = _found & 0xFFFFFF;
    }

    //Set our shader uniforms before use
    shader_set(__shd_scribble_bake_outline_8dir);
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_vOutlineColor"), color_get_red(  _outline_color)/255,
                                                                                  color_get_green(_outline_color)/255,
                                                                                  color_get_blue( _outline_color)/255);
    shader_reset();

    //Run the baking operation
    scribble_font_bake_shader(_source_font_name, _new_font_name, __shd_scribble_bake_outline_8dir,
                              2, 1, 1, 1, 1,
                              1, _smooth, _textureSize);
}
