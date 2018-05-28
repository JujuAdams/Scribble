/// @param font
/// @param string

var _font   = argument0;
var _string = argument1;

var _font_glyphs_map = global.__scribble_glyphs_map[? _font ];

var _x     = 0;
var _width = 0;

var _length = string_length( _string );
for( var _i = 1; _i <= _length-1; _i++ ) {
    
    var _char = string_copy( _string, _i, 1 );
    if ( ord( _char ) == 10 ) _x = 0;
    
    var _array = _font_glyphs_map[? _char ];
    if ( _array == undefined ) continue;
    
    _x += _array[ __E_SCRIBBLE_GLYPH.SHF ];
    _width = max( _width, _x );
    
}

var _char = string_copy( _string, _length, 1 );
var _array = _font_glyphs_map[? _char ];
if ( _array != undefined ) {
    _x += _array[ __E_SCRIBBLE_GLYPH.DX ] + _array[ __E_SCRIBBLE_GLYPH.W ];
    _width = max( _width, _x );
}

return _width;