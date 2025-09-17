// Feather disable all
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
    
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    
    var _i = 0;
    repeat(4)
    {
        var _struct = _fontDataMap[? _font_names[_i]];
        if (is_struct(_struct))
        {
            with(_struct)
            {
                __styleRegular     = _font_names[0];
                __styleBold        = _font_names[1];
                __styleItalic      = _font_names[2];
                __styleBoldItalic = _font_names[3];
            }
        }
        
        _i++;
    }
}
