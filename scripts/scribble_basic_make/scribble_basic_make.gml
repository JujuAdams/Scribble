/// @param font
/// @param string
/// @param [colour]
/// @param [alpha]

var _font   = argument[0];
var _string = __scribble_replace_newlines( argument[1] );
var _colour = ((argument_count < 3) || ( argument[2] == undefined))? c_white : argument[2];
var _alpha  = ((argument_count < 4) || ( argument[3] == undefined))? 1       : argument[3];

var _font_glyphs_map = global.__scribble_glyphs_map[? _font ];

var _vbuff = vertex_create_buffer();
vertex_begin( _vbuff, global.__scribble_vertex_format );

var _line = 0;
var _line_max = string_count( "\n", _string );

var _x = 0;
var _y = 0;
var _line_height = scribble_font_char_get_height( _font, " " );

var _length = string_length( _string );
for( var _pos = 1; _pos <= _length; _pos++ ) {
    
    var _char = string_copy( _string, _pos, 1 );
    
    if ( _char == "\n" ) {
        _line++;
        _x = 0;
        _y += _line_height;
    }
    
    var _array = _font_glyphs_map[? _char ];
    if ( _array == undefined ) continue;
    
    var _w   = _array[ __E_SCRIBBLE_GLYPH.W   ];
    var _h   = _array[ __E_SCRIBBLE_GLYPH.H   ];
    var _u0  = _array[ __E_SCRIBBLE_GLYPH.U0  ];
    var _v0  = _array[ __E_SCRIBBLE_GLYPH.V0  ];
    var _u1  = _array[ __E_SCRIBBLE_GLYPH.U1  ];
    var _v1  = _array[ __E_SCRIBBLE_GLYPH.V1  ];
    var _dx  = _array[ __E_SCRIBBLE_GLYPH.DX  ];
    var _dy  = _array[ __E_SCRIBBLE_GLYPH.DY  ];
    var _shf = _array[ __E_SCRIBBLE_GLYPH.SHF ];
    
    var _l = _x + _dx;
    var _t = _y + _dy;
    var _r = _l + _w;
    var _b = _t + _h;
                 
    var _char_pc = _pos / _length;
    var _line_pc = _line / _line_max;
    
    vertex_position( _vbuff, _l, _t ); vertex_texcoord( _vbuff, _u0, _v0 ); vertex_colour( _vbuff, _colour, _alpha ); vertex_float4( _vbuff, _char_pc, _line_pc, __E_SCRIBBLE_HYPERLINK.UNLINKED, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, 0, 0, 0 );
    vertex_position( _vbuff, _l, _b ); vertex_texcoord( _vbuff, _u0, _v1 ); vertex_colour( _vbuff, _colour, _alpha ); vertex_float4( _vbuff, _char_pc, _line_pc, __E_SCRIBBLE_HYPERLINK.UNLINKED, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, 0, 0, 0 );
    vertex_position( _vbuff, _r, _b ); vertex_texcoord( _vbuff, _u1, _v1 ); vertex_colour( _vbuff, _colour, _alpha ); vertex_float4( _vbuff, _char_pc, _line_pc, __E_SCRIBBLE_HYPERLINK.UNLINKED, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, 0, 0, 0 );
    vertex_position( _vbuff, _r, _b ); vertex_texcoord( _vbuff, _u1, _v1 ); vertex_colour( _vbuff, _colour, _alpha ); vertex_float4( _vbuff, _char_pc, _line_pc, __E_SCRIBBLE_HYPERLINK.UNLINKED, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, 0, 0, 0 );
    vertex_position( _vbuff, _r, _t ); vertex_texcoord( _vbuff, _u1, _v0 ); vertex_colour( _vbuff, _colour, _alpha ); vertex_float4( _vbuff, _char_pc, _line_pc, __E_SCRIBBLE_HYPERLINK.UNLINKED, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, 0, 0, 0 );
    vertex_position( _vbuff, _l, _t ); vertex_texcoord( _vbuff, _u0, _v0 ); vertex_colour( _vbuff, _colour, _alpha ); vertex_float4( _vbuff, _char_pc, _line_pc, __E_SCRIBBLE_HYPERLINK.UNLINKED, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, 0, 0, 0 );
    
    _x += _shf;
    
}

vertex_end( _vbuff );
return _vbuff;