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

var _glyph_map = global.__scribble_glyphs_map[? _font ];
var _glyph_data = _glyph_map[? _character ];

if ( _relative )
{
    _glyph_data[@ _property ] += _value;
}
else
{
    _glyph_data[@ _property ] = _value;
}