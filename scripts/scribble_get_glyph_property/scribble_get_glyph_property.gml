/// @param fontName
/// @param character
/// @param property

var _font      = argument0;
var _character = argument1;
var _property  = argument2;

var _glyph_map = global.__scribble_glyphs_map[? _font ];
var _glyph_data = _glyph_map[? _character ];
return _glyph_data[ _property ];