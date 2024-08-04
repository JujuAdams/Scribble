// Feather disable all
/// Creates a new font with an outline based on a given source font
///
/// @param sourceFontName   Name, as a string, of the font to use as a basis for the effect
/// @param newFontName      Name of the new font to create, as a string
/// @param shadowX          
/// @param shadowY          
/// @param outlineMode      0 = No outline, 1 = 4-dir, 2 = 8-dir, 3 = 8-dir, 2px thick
/// @param separation       Additional separation to add between glyphs
/// @param smooth           Whether or not to interpolate the effect. Set to <false> for pixel fonts, set to <true> for anti-aliased fonts
/// @param [textureSize]

function scribble_font_bake_outline_and_shadow(_sourceFontName, _newFontName, _dX, _dY, _outlineMode, _separation, _smooth, _textureSize = undefined)
{
    var _outlineSize = 0;
    var _shader = __shd_scribble_bake_effect_no_outline;
    
    if (_outlineMode == 0)
    {
        //No outline
    }
    else if (_outlineMode == 1)
    {
        _outlineSize = 1;
        _shader = __shd_scribble_bake_effect_4dir;
    }
    else if (_outlineMode == 2)
    {
        _outlineSize = 1;
        _shader = __shd_scribble_bake_effect_8dir;
    }
    else if (_outlineMode == 3)
    {
        _outlineSize = 2;
        _shader = __shd_scribble_bake_effect_8dir_2px;
    }
    
    //Set our shader uniforms before use
    shader_set(_shader);
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_vShadowDelta"), _dX, _dY);
    shader_reset();
    
    //Run the baking operation
    scribble_font_bake_shader(_sourceFontName, _newFontName, _shader,
                              2, _outlineSize + max(0, -_dX), _outlineSize + max(0, -_dY), _outlineSize + max(0, _dX), _outlineSize + max(0, _dY),
                              _separation, _smooth, _textureSize, true);
}
