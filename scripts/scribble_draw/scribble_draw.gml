/// @param json
/// @param [x]
/// @param [y]

var _json = argument[0];
var _x    = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : 0;
var _y    = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 0;

if ( SCRIBBLE_COMPATIBILITY_MODE )
{
    #region Compatibility mode
    
    var _old_matrix = undefined;
    var _old_halign = draw_get_halign();
    var _old_valign = draw_get_valign();
    var _old_font   = draw_get_font();
    var _old_alpha  = draw_get_alpha();
    var _old_colour = draw_get_colour();
    
    var _sprite_slot_array = array_create( SCRIBBLE_MAX_SPRITE_SLOTS, 0 );
    var _sprite_slot_list = _json[? "sprite slots" ];
    
    var _size = ds_list_size( _sprite_slot_list );
    for( var _i = 0; _i < _size; _i++ ) {
        var _slot_map = _sprite_slot_list[| _i ];
        _sprite_slot_array[ _i ] = _slot_map[? "image" ];
    }



    var _char_count = 0;
    var _total_chars = _json[? "char fade t" ] * _json[? "length" ];

    var _real_x = _x + _json[? "left" ];
    var _real_y = _y + _json[? "top" ];

    if ( _real_x != 0 ) || ( _real_y != 0 )
    {
        var _old_matrix = matrix_get( matrix_world );
        var _matrix;
        _matrix[15] =  1;
        _matrix[ 0] =  1;
        _matrix[ 5] =  1;
        _matrix[10] =  1;
        _matrix[12] = _real_x;
        _matrix[13] = _real_y;
        matrix_set( matrix_world, _matrix );
    }

    var _text_root_list = _json[? "lines list" ];
    var _lines_count = ds_list_size( _text_root_list );
    for( var _line = 0; _line < _lines_count; _line++ )
    {
        var _line_array = _text_root_list[| _line ];
        var _line_x = _line_array[ E_SCRIBBLE_LINE.X ];
        var _line_y = _line_array[ E_SCRIBBLE_LINE.Y ];
    
        var _line_word_array = _line_array[ E_SCRIBBLE_LINE.WORDS ];
        var _words_count = array_length_1d( _line_word_array );
        for( var _word = 0; _word < _words_count; _word++ )
        {
            var _word_array = _line_word_array[ _word ];
            var _x          = _word_array[ E_SCRIBBLE_WORD.X      ] + _line_x;
            var _y          = _word_array[ E_SCRIBBLE_WORD.Y      ] + _line_y;
            var _sprite     = _word_array[ E_SCRIBBLE_WORD.SPRITE ];
        
            if ( _sprite >= 0 )
            {
                if ( _char_count + 1 > _total_chars ) continue;
                ++_char_count;
            
                var _sprite_slot = _word_array[ E_SCRIBBLE_WORD.SPRITE_SLOT ];
                _x -= sprite_get_xoffset( _sprite );
                _y -= sprite_get_yoffset( _sprite );
            
                if ( _sprite_slot == undefined )
                {
                    draw_sprite( _sprite, _word_array[ E_SCRIBBLE_WORD.IMAGE ], _x, _y );
                }
                else 
                {
                    draw_sprite( _sprite, _sprite_slot_array[ _sprite_slot ], _x, _y );
                }
            }
            else
            {
                var _string    = _word_array[ E_SCRIBBLE_WORD.STRING    ];
                var _length    = _word_array[ E_SCRIBBLE_WORD.LENGTH    ];
                var _font_name = _word_array[ E_SCRIBBLE_WORD.FONT      ];
                var _colour    = _word_array[ E_SCRIBBLE_WORD.COLOUR    ];
            
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
                    var _font = global.__scribble_sprite_font_map[? _font_name ];
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

    if ( _old_matrix != undefined ) matrix_set( matrix_world, _old_matrix );
    
    #endregion
}
else
{
    #region Normal mode
    
    var _sprite_slot_array = array_create( SCRIBBLE_MAX_SPRITE_SLOTS, 0 );
    var _sprite_slot_list = _json[? "sprite slots" ];
    var _size = ds_list_size( _sprite_slot_list );
    for( var _i = 0; _i < _size; _i++ ) {
        var _slot_map = _sprite_slot_list[| _i ];
        _sprite_slot_array[ _i ] = _slot_map[? "image" ];
    }
    
    var _real_x      = _x + _json[? "left" ];
    var _real_y      = _y + _json[? "top" ];
    var _vbuff_list  = _json[? "vertex buffer list" ];
    var _vbuff_count = ds_list_size( _vbuff_list );
    
    if ( _real_x != 0 ) || ( _real_y != 0 ) {
        var _old_matrix = matrix_get( matrix_world );
        var _matrix;
        _matrix[15] =  1;
        _matrix[ 0] =  1;
        _matrix[ 5] =  1;
        _matrix[10] =  1;
        _matrix[12] = _real_x;
        _matrix[13] = _real_y;
        matrix_set( matrix_world, _matrix );
    }
    
    shader_set( shScribbleLight );
    shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fTime" ), SCRIBBLE_TIME );

    scribble_shader_alpha(          draw_get_alpha() ); //Feature reduced in "light" version, now inherits draw_get_alpha()
    scribble_shader_options(        _json[? "wave size" ], _json[? "shake size" ], _json[? "rainbow weight" ] );
    scribble_shader_character_fade( _json[? "char fade t" ], _json[? "char fade smoothness" ] );
    scribble_shader_line_fade(      _json[? "line fade t" ], _json[? "line fade smoothness" ] );
    scribble_shader_sprite_slots(   _sprite_slot_array );
    
    for( var _i = 0; _i < _vbuff_count; _i++ ) {
        var _vbuff_map = _vbuff_list[| _i ];
        vertex_submit( _vbuff_map[? "vertex buffer" ], pr_trianglelist, _vbuff_map[? "texture" ] );
    }
    
    shader_reset();
    
    if ( _x != 0 ) || ( _y != 0 ) matrix_set( matrix_world, _old_matrix );
    
    #endregion
}