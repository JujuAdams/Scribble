/// @param fontName
/// @param character
/// @param property
/// @param value
/// @param [relative]

var _font      = argument[0];
var _character = argument[1];
var _property  = argument[2];
var _value     = argument[3];
var _relative  = (argument_count > 4)? argument[4] : false;

var _font_data  = global.__scribble_font_data[? _font ];
var _glyphs_map = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_DS ];
var _glyph_data = _glyphs_map[? _character ];

if ( _relative )
{
    _glyph_data[@ _property ] += _value;
}
else
{
    _glyph_data[@ _property ] = _value;
}