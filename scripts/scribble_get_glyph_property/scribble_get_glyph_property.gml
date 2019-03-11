/// @param fontName
/// @param character
/// @param property

var _font      = argument0;
var _character = argument1;
var _property  = argument2;

var _font_data  = global.__scribble_font_data[? _font ];
var _glyphs_map = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_DS ];
var _glyph_data = _glyphs_map[? _character ];
return _glyph_data[ _property ];