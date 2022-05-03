/// Creates a new font with an outline based on a given source font
///
/// @param sourceFontName   Name, as a string, of the font to use as a basis for the effect
/// @param newFontName      Name of the new font to create, as a strintg
/// @param dX               
/// @param dY               
/// @param shadowColour     Colour of the shadow
/// @param shadowAlpha      Alpha of the shadow
/// @param separation       Additional separation to add between glyphs
/// @param smooth           Whether or not to interpolate the outline. Set to <false> for pixel fonts, set to <true> for anti-aliased fonts

function scribble_font_bake_shadow(_source_font_name, _new_font_name, _dx, _dy, _shadow_color, _shadow_alpha, _separation, _smooth)
{
    if (is_string(_shadow_color))
    {
        var _found = global.__scribble_colours[$ _shadow_color];
        if (_shadow_color == undefined)
        {
            __scribble_error("Colour \"", _shadow_color, "\" not recognised");
            exit;
        }
        _shadow_color = _found & 0xFFFFFF;
    }

    //Set our shader uniforms before use
    shader_set(__shd_scribble_bake_shadow);
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_vShadowDelta"), _dx, _dy);
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_vShadowColor"), color_get_red(  _shadow_color)/255,
                                                                                 color_get_green(_shadow_color)/255,
                                                                                 color_get_blue( _shadow_color)/255,
                                                                                 _shadow_alpha);
    shader_reset();

    //Run the baking operation
    scribble_font_bake_shader(_source_font_name, _new_font_name, __shd_scribble_bake_shadow,
                              2, max(0, -_dx), max(0, -_dx), max(0, _dx), max(0, _dy),
                              _separation, _smooth);
}