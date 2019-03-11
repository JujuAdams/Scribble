/// @param fontName
/// @param character
/// @param property

var _font      = argument0;
var _character = argument1;
var _property  = argument2;

var _font_data = global.__scribble_font_data[? _font ];

var _array = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_ARRAY ];
if ( _array == undefined )
{
    //If the glyph array doesn't exist for this font, use the ds_map fallback
    var _map = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_DS ];
    var _glyph_data = _map[? _character ];
}
else
{
    var _glyph_data = _array[ ord(_character) - _font_data[ __E_SCRIBBLE_FONT.GLYPH_MIN ] ];
}

return _glyph_data[ _property ];