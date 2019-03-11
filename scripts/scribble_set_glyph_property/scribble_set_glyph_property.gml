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

if ( _relative )
{
    _glyph_data[@ _property ] += _value;
}
else
{
    _glyph_data[@ _property ] = _value;
}