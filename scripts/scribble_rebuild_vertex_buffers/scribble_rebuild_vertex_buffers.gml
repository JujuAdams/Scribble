/// @param json
/// @param [force_offset_x]
/// @param [force_offset_y]

var _json           = argument[0];
var _force_offset_x = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : 0;
var _force_offset_y = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 0;

_force_offset_x += _json[? "left" ];
_force_offset_y += _json[? "top"  ];

var _hyperlink_map = _json[? "hyperlinks"         ];
var _vbuff_list    = _json[? "vertex buffer list" ];

var _texture_to_vbuff_map = ds_map_create();

var _previous_font = "";
var _previous_texture = -1;
var _text_char = 0;
var _max_char  = _json[? "length" ] - 1;

var _lines = _json[? "lines list" ];
var _lines_size = ds_list_size( _lines );
for( var _line = 0; _line < _lines_size; _line++ )
{
    var _line_array = _lines[| _line ];
    var _line_l = _line_array[ E_SCRIBBLE_LINE.X ] + _force_offset_x;
    var _line_t = _line_array[ E_SCRIBBLE_LINE.Y ] + _force_offset_y;
    
    var _line_pc = _line / _lines_size;
    
    var _line_word_array = _line_array[ E_SCRIBBLE_LINE.WORDS ];
    var _words_count = array_length_1d( _line_word_array );
    for( var _word = 0; _word < _words_count; _word++ )
    {
        var _word_array = _line_word_array[ _word ];
        var _word_l   = _line_l + _word_array[ E_SCRIBBLE_WORD.X ];
        var _word_t   = _line_t + _word_array[ E_SCRIBBLE_WORD.Y ];
        var _sprite   = _word_array[ E_SCRIBBLE_WORD.SPRITE ];
        
        var _hyperlink_index = __E_SCRIBBLE_HYPERLINK.UNLINKED;
        var _hyperlink = _word_array[ E_SCRIBBLE_WORD.HYPERLINK ];
        var _hyperlink_data_map = _hyperlink_map[? _hyperlink ];
        if ( _hyperlink_data_map != undefined ) _hyperlink_index = _hyperlink_data_map[? "index" ];
        
        if ( _sprite != noone )
        {
            #region Add a sprite
            
            _previous_font = "";
            
            var _char_pc     = _text_char / _max_char;
            var _sprite_slot = _word_array[ E_SCRIBBLE_WORD.SPRITE_SLOT ];
            var _colour      = _word_array[ E_SCRIBBLE_WORD.COLOUR      ];
            var _rainbow     = _word_array[ E_SCRIBBLE_WORD.RAINBOW     ];
            var _shake       = _word_array[ E_SCRIBBLE_WORD.SHAKE       ];
            var _wave        = _word_array[ E_SCRIBBLE_WORD.WAVE        ];
            
            if ( _sprite_slot == undefined )
            {
                var _image_min = _word_array[ E_SCRIBBLE_WORD.IMAGE ];
                var _image_max = _image_min;
                var _no_animation = true;
            }
            else
            {
                var _image_min = 0;
                var _image_max = sprite_get_number( _sprite )-1;
                var _no_animation = false;
            }
            
            for( var _image = _image_min; _image <= _image_max; _image++ )
            {
                var _sprite_texture = sprite_get_texture( _sprite, _image );
            
                if ( _sprite_texture != _previous_texture )
                {
                    _previous_texture = _sprite_texture;
                    
                    var _vbuff_map = _texture_to_vbuff_map[? _sprite_texture ];
                    if ( _vbuff_map == undefined )
                    {
                        var _vbuff = vertex_create_buffer();
                        vertex_begin( _vbuff, global.__scribble_vertex_format );
                
                        _vbuff_map = ds_map_create();
                        _vbuff_map[? "vertex buffer" ] = _vbuff;
                        _vbuff_map[? "sprite"        ] = _sprite;
                        _vbuff_map[? "texture"       ] = _sprite_texture;
                        ds_list_add( _vbuff_list, _vbuff_map );
                        ds_list_mark_as_map( _vbuff_list, ds_list_size( _vbuff_list )-1 );
                
                        _texture_to_vbuff_map[? _sprite_texture ] = _vbuff_map;
                    }
                    else
                    {
                        var _vbuff = _vbuff_map[? "vertex buffer" ];
                    }
                }
            
                var _uvs = sprite_get_uvs( _sprite, _image );
                var _glyph_l = _word_l  + _uvs[4] + sprite_get_xoffset( _sprite );
                var _glyph_t = _word_t  + _uvs[5] + sprite_get_yoffset( _sprite );
                var _glyph_r = _glyph_l + _uvs[6]*sprite_get_width(  _sprite );
                var _glyph_b = _glyph_t + _uvs[7]*sprite_get_height( _sprite );
                
                var _compound_index = _no_animation? __SCRIBBLE_NO_SPRITE : ( SCRIBBLE_MAX_SPRITE_SLOTS*_image + _sprite_slot );
                
                vertex_position( _vbuff, _glyph_l, _glyph_t ); vertex_texcoord( _vbuff, _uvs[0], _uvs[1] ); vertex_colour( _vbuff, c_white, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, _compound_index ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_l, _glyph_b ); vertex_texcoord( _vbuff, _uvs[0], _uvs[3] ); vertex_colour( _vbuff, c_white, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, _compound_index ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_r, _glyph_b ); vertex_texcoord( _vbuff, _uvs[2], _uvs[3] ); vertex_colour( _vbuff, c_white, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, _compound_index ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_r, _glyph_b ); vertex_texcoord( _vbuff, _uvs[2], _uvs[3] ); vertex_colour( _vbuff, c_white, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, _compound_index ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_r, _glyph_t ); vertex_texcoord( _vbuff, _uvs[2], _uvs[1] ); vertex_colour( _vbuff, c_white, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, _compound_index ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_l, _glyph_t ); vertex_texcoord( _vbuff, _uvs[0], _uvs[1] ); vertex_colour( _vbuff, c_white, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, _compound_index ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
            }
            
            _text_char++;
            
            #endregion
        }
        else
        {
            #region Check the font and texture to see if we need a new vertex buffer
            var _font = _word_array[ E_SCRIBBLE_WORD.FONT ];
            
            if ( _font != _previous_font )
            {
                _previous_font = _font;
                
                var _font_glyphs_map = global.__scribble_glyphs_map[? _font ];
                var _font_sprite     = global.__scribble_image_map[?  _font ];
                var _font_texture    = sprite_get_texture( _font_sprite, 0 );     
                
                if ( _font_texture != _previous_texture )
                {
                    _previous_texture = _font_texture;
                    
                    var _vbuff_map = _texture_to_vbuff_map[? _font_texture ];
                    if ( _vbuff_map == undefined )
                    {
                        var _vbuff = vertex_create_buffer();
                        vertex_begin( _vbuff, global.__scribble_vertex_format );
                
                        _vbuff_map = ds_map_create();
                        _vbuff_map[? "vertex buffer" ] = _vbuff;
                        _vbuff_map[? "sprite"        ] = _font_sprite;
                        _vbuff_map[? "texture"       ] = _font_texture;
                        ds_list_add( _vbuff_list, _vbuff_map );
                        ds_list_mark_as_map( _vbuff_list, ds_list_size( _vbuff_list )-1 );
                
                        _texture_to_vbuff_map[? _font_texture ] = _vbuff_map;
                    }
                    else
                    {
                        var _vbuff = _vbuff_map[? "vertex buffer" ];
                    }
                }
            }
            #endregion
            
            #region Add vertex data for each character in the string
            
            var _colour  = _word_array[ E_SCRIBBLE_WORD.COLOUR  ];
            var _rainbow = _word_array[ E_SCRIBBLE_WORD.RAINBOW ];
            var _shake   = _word_array[ E_SCRIBBLE_WORD.SHAKE   ];
            var _wave    = _word_array[ E_SCRIBBLE_WORD.WAVE    ];
            
            var _str = _word_array[ E_SCRIBBLE_WORD.STRING ];
            var _string_size = string_length( _str );
            
            var _char_l = _word_l;
            var _char_t = _word_t;
            for( var _char = 1; _char <= _string_size; _char++ )
            {
                var _array = _font_glyphs_map[? string_copy( _str, _char, 1 ) ];
                if ( _array == undefined ) continue;
                
                var _glyph_w   = _array[ __E_SCRIBBLE_GLYPH.W   ];
                var _glyph_h   = _array[ __E_SCRIBBLE_GLYPH.H   ];
                var _glyph_u0  = _array[ __E_SCRIBBLE_GLYPH.U0  ];
                var _glyph_v0  = _array[ __E_SCRIBBLE_GLYPH.V0  ];
                var _glyph_u1  = _array[ __E_SCRIBBLE_GLYPH.U1  ];
                var _glyph_v1  = _array[ __E_SCRIBBLE_GLYPH.V1  ];
                var _glyph_dx  = _array[ __E_SCRIBBLE_GLYPH.DX  ];
                var _glyph_dy  = _array[ __E_SCRIBBLE_GLYPH.DY  ];
                var _glyph_shf = _array[ __E_SCRIBBLE_GLYPH.SHF ];
                
                var _glyph_l = _char_l + _glyph_dx;
                var _glyph_t = _char_t + _glyph_dy;
                var _glyph_r = _glyph_l + _glyph_w;
                var _glyph_b = _glyph_t + _glyph_h;
                
                var _char_pc = _text_char / _max_char;
                
                vertex_position( _vbuff, _glyph_l, _glyph_t ); vertex_texcoord( _vbuff, _glyph_u0, _glyph_v0 ); vertex_colour( _vbuff, _colour, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_l, _glyph_b ); vertex_texcoord( _vbuff, _glyph_u0, _glyph_v1 ); vertex_colour( _vbuff, _colour, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_r, _glyph_b ); vertex_texcoord( _vbuff, _glyph_u1, _glyph_v1 ); vertex_colour( _vbuff, _colour, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_r, _glyph_b ); vertex_texcoord( _vbuff, _glyph_u1, _glyph_v1 ); vertex_colour( _vbuff, _colour, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_r, _glyph_t ); vertex_texcoord( _vbuff, _glyph_u1, _glyph_v0 ); vertex_colour( _vbuff, _colour, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                vertex_position( _vbuff, _glyph_l, _glyph_t ); vertex_texcoord( _vbuff, _glyph_u0, _glyph_v0 ); vertex_colour( _vbuff, _colour, 1 ); vertex_float4( _vbuff, _char_pc, _line_pc, _hyperlink_index, __SCRIBBLE_NO_SPRITE ); vertex_float3( _vbuff, _wave, _shake, _rainbow );
                
                _char_l += _glyph_shf;
                _text_char++;
            }
            
            #endregion
        }
    }
}

//Finish off and freeze all the vertex buffers we created
var _vbuff_count = ds_list_size( _vbuff_list );
for( var _i = 0; _i < _vbuff_count; _i++ )
{
    var _vbuff_map = _vbuff_list[| _i ];
    var _vbuff = _vbuff_map[? "vertex buffer" ];
    vertex_end( _vbuff );
    vertex_freeze( _vbuff );
}

ds_map_destroy( _texture_to_vbuff_map );

return _vbuff;