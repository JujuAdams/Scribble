// Feather disable all
/// Associates four fonts together for use with [r] [b] [i] [bi] font tags
/// Use <undefined> for any style you don't want to set a font for
/// 
/// @param regularFont     Name of font to use for the regular style
/// @param boldFont        Name of font to use for the bold style
/// @param italicFont      Name of font to use for the italic style
/// @param boldItalicFont  Name of font to use for the bold-italic style

function scribble_font_set_style_family(_rFont, _bFont, _iFont, _biFont)
{
    var _fontNames = array_create(4, undefined);
    _fontNames[@ 0] = is_string(_rFont )? _rFont  : undefined;
    _fontNames[@ 1] = is_string(_bFont )? _bFont  : undefined;
    _fontNames[@ 2] = is_string(_iFont )? _iFont  : undefined;
    _fontNames[@ 3] = is_string(_biFont)? _biFont : undefined;
    
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    
    var _i = 0;
    repeat(4)
    {
        var _struct = _fontDataMap[? _fontNames[_i]];
        if (is_struct(_struct))
        {
            with(_struct)
            {
                __styleRegular    = _fontNames[0];
                __styleBold       = _fontNames[1];
                __styleItalic     = _fontNames[2];
                __styleBoldItalic = _fontNames[3];
            }
        }
        
        _i++;
    }
}
