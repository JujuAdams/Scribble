/// @param json
/// @param [x]
/// @param [y]
/// @param [xscale]
/// @param [yscale]
/// @param [angle]
/// @param [colour]
/// @param [alpha]

var _json   = argument[0];
var _x      = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : 0;
var _y      = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 0;
var _xscale = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 1;
var _yscale = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 1;
var _angle  = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
var _colour = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : draw_get_colour();
var _alpha  = ((argument_count > 7) && (argument[7] != undefined))? argument[7] : draw_get_alpha();

var _old_matrix = matrix_get( matrix_world );

if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
{
    var _matrix = matrix_build( _json[| __E_SCRIBBLE.LEFT ] + _x, _json[| __E_SCRIBBLE.TOP ] + _y, 0,   0,0,0,   1,1,1 );
}
else
{
    var _matrix = matrix_build( _json[| __E_SCRIBBLE.LEFT ], _json[| __E_SCRIBBLE.TOP ], 0,   0,0,0,   1,1,1 );
        _matrix = matrix_multiply( _matrix, matrix_build( _x,_y,0,   0,0,_angle,   _xscale,_yscale,1 ) );
}

_matrix = matrix_multiply( _matrix, _old_matrix );
matrix_set( matrix_world, _matrix );

if (SCRIBBLE_COMPATIBILITY_DRAW)
{
    #region Compatibility mode
    
    var _old_halign = 0; //draw_get_halign();
    var _old_valign = 0; //draw_get_valign();
    var _old_font   = 0; //draw_get_font();
    var _old_alpha  = draw_get_alpha();
    var _old_colour = draw_get_colour();
    
    var _char_count = 0;
    var _total_chars = _json[| __E_SCRIBBLE.CHAR_FADE_T ] * _json[| __E_SCRIBBLE.LENGTH ];

    var _text_root_list = _json[| __E_SCRIBBLE.LINE_LIST ];
    var _lines_count = ds_list_size( _text_root_list );
    for( var _line = 0; _line < _lines_count; _line++ )
    {
        var _line_array = _text_root_list[| _line ];
        var _line_x = _line_array[ __E_SCRIBBLE_LINE.X ];
        var _line_y = _line_array[ __E_SCRIBBLE_LINE.Y ];
    
        var _line_word_array = _line_array[ __E_SCRIBBLE_LINE.WORDS ];
        var _words_count = array_length_1d( _line_word_array );
        for( var _word = 0; _word < _words_count; _word++ )
        {
            var _word_array = _line_word_array[ _word ];
            var _x          = _word_array[ __E_SCRIBBLE_WORD.X      ] + _line_x;
            var _y          = _word_array[ __E_SCRIBBLE_WORD.Y      ] + _line_y;
            var _sprite     = _word_array[ __E_SCRIBBLE_WORD.SPRITE ];
        
            if ( _sprite >= 0 )
            {
                if ( _char_count + 1 > _total_chars ) continue;
                ++_char_count;
                
                _x -= sprite_get_xoffset( _sprite );
                _y -= sprite_get_yoffset( _sprite );
                
                draw_sprite( _sprite, _word_array[ __E_SCRIBBLE_WORD.IMAGE ], _x, _y );
            }
            else
            {
                var _string    = _word_array[ __E_SCRIBBLE_WORD.STRING    ];
                var _length    = _word_array[ __E_SCRIBBLE_WORD.LENGTH    ];
                var _font_name = _word_array[ __E_SCRIBBLE_WORD.FONT      ];
                var _colour    = _word_array[ __E_SCRIBBLE_WORD.COLOUR    ];
            
                if ( _char_count + _length > _total_chars )
                {
                    _string = string_copy( _string, 1, _total_chars - _char_count );
                    _char_count = _total_chars;
                }
                else
                {
                    _char_count += _length;
                }
            
                var _font = asset_get_index( _font_name );
                if ( _font >= 0 ) && ( asset_get_type( _font_name ) == asset_font )
                {
                    draw_set_font( _font );
                }
                else
                {
                    var _font = global.__scribble_spritefont_map[? _font_name ];
                    if ( _font != undefined ) draw_set_font( _font );
                }
            
                draw_set_colour( _colour );
                draw_text( _x, _y, _string );
            }
            if ( _char_count >= _total_chars ) break;
        }
        if ( _char_count >= _total_chars ) break;
    }

    draw_set_halign( _old_halign );
    draw_set_valign( _old_valign );
    draw_set_font(   _old_font   );
    draw_set_colour( _old_colour );
    draw_set_alpha(  _old_alpha  );
    
    #endregion
}
else
{
    #region Normal mode
    
    var _vbuff_list  = _json[| __E_SCRIBBLE.VERTEX_BUFFER_LIST ];
    var _vbuff_count = ds_list_size( _vbuff_list );
    
    var _char_smoothness = 0;
    var _char_t          = 1;
    
    var _line_smoothness = 0;
    var _line_t          = 1;
    
    switch( _json[| __E_SCRIBBLE.TW_METHOD ] )
    {
        case SCRIBBLE_TYPEWRITER_WHOLE:
            if ( _json[| __E_SCRIBBLE.TW_DIRECTION ] > 0 )
            {
                _alpha *= _json[| __E_SCRIBBLE.TW_POSITION ];
            }
            else
            {
                _alpha *= 1 - _json[| __E_SCRIBBLE.TW_POSITION ];
            }
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            _char_smoothness = _json[| __E_SCRIBBLE.TW_SMOOTHNESS ] / _json[| __E_SCRIBBLE.LENGTH ];
            _char_t          = _json[| __E_SCRIBBLE.CHAR_FADE_T ] / (1-_char_smoothness);
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            _line_smoothness = _json[| __E_SCRIBBLE.TW_SMOOTHNESS ] / _json[| __E_SCRIBBLE.LINES ];
            _line_t          = _json[| __E_SCRIBBLE.LINE_FADE_T ] / (1-_line_smoothness);
        break;
    }
    
    shader_set( shScribble );
    shader_set_uniform_f( global.__scribble_uniform_time           , _json[| __E_SCRIBBLE.ANIMATION_TIME ]*SCRIBBLE_ANIMATION_SPEED );
    shader_set_uniform_f( global.__scribble_uniform_options        , _json[| __E_SCRIBBLE.WAVE_SIZE      ],
                                                                     _json[| __E_SCRIBBLE.SHAKE_SIZE     ],
                                                                     _json[| __E_SCRIBBLE.RAINBOW_WEIGHT ] );
    
    shader_set_uniform_f( global.__scribble_uniform_char_t         , _char_t          );
    shader_set_uniform_f( global.__scribble_uniform_char_smoothness, _char_smoothness );
    
    shader_set_uniform_f( global.__scribble_uniform_line_t         , _line_t          );
    shader_set_uniform_f( global.__scribble_uniform_line_smoothness, _line_smoothness );
    
    shader_set_uniform_f( global.__scribble_uniform_colour         , colour_get_red(   _colour )/255,
                                                                     colour_get_green( _colour )/255,
                                                                     colour_get_blue(  _colour )/255,
                                                                     _alpha );
    
    for( var _i = 0; _i < _vbuff_count; _i++ )
    {
        var _vbuff_data = _vbuff_list[| _i ];
        vertex_submit( _vbuff_data[| __E_SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER ], pr_trianglelist, _vbuff_data[| __E_SCRIBBLE_VERTEX_BUFFER.TEXTURE ] );
    }
    
    shader_reset();
    
    #endregion
}

matrix_set( matrix_world, _old_matrix );