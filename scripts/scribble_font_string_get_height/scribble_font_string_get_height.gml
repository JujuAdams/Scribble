/// @param font
/// @param string

var _font   = argument0;
var _string = argument1;

var _font_glyphs_map = global.__scribble_glyphs_map[? _font ];

var _line_height = scribble_font_char_get_height( _font, " " );

var _y      = 0;
var _height = 0;

var _length = string_length( _string );
for( var _i = 1; _i <= _length-1; _i++ ) {
    
    var _char = string_copy( _string, _i, 1 );
    if ( ord( _char ) == 10 ) _y += _line_height;
    
    var _array = _font_glyphs_map[? _char ];
    if ( _array == undefined ) continue;
    
    _height = max( _height, _y + _array[ __E_SCRIBBLE_GLYPH.H ] );
    
}

var _char = string_copy( _string, _length, 1 );
var _array = _font_glyphs_map[? _char ];
if ( _array != undefined )  _height = max( _height, _y + _array[ __E_SCRIBBLE_GLYPH.DY ] + _array[ __E_SCRIBBLE_GLYPH.H ] );

return _height;