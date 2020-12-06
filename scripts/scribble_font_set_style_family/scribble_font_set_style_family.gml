/// Associates four fonts together for use with [r] [b] [i] [bi] font tags
/// Use <undefined> for any style you don't want to set a font for
/// 
/// @param regularFont     Name of font to use for the regular style
/// @param boldFont        Name of font to use for the bold style
/// @param italicFont      Name of font to use for the italic style
/// @param boldItalicFont  Name of font to use for the bold-italic style

function scribble_font_set_style_family(_r_font, _b_font, _i_font, _bi_font)
{
    var _font_names = array_create(4, undefined);
    _font_names[@ 0] = is_string(_r_font )? _r_font  : undefined;
    _font_names[@ 1] = is_string(_b_font )? _b_font  : undefined;
    _font_names[@ 2] = is_string(_i_font )? _i_font  : undefined;
    _font_names[@ 3] = is_string(_bi_font)? _bi_font : undefined;
    
    var _i = 0;
    repeat(4)
    {
        var _struct = global.__scribble_font_data[? _font_names[_i]];
        if (is_struct(_struct))
        {
            with(_struct)
            {
                style_regular     = _font_names[0];
                style_bold        = _font_names[1];
                style_italic      = _font_names[2];
                style_bold_italic = _font_names[3];
            }
        }
        
        _i++;
    }
}