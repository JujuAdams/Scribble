/// @description Draws a SCRIBBLE JSON
///
/// April 2017
/// Juju Adams
/// julian.adams@email.com
/// @jujuadams
///
/// This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
/// https://creativecommons.org/licenses/by-nc-sa/4.0/
///
/// @param x
/// @param y
/// @param json
/// @param [colour]
/// @param [alpha]
/// @param [fade]

var _old_alpha = draw_get_alpha();

var _x          = argument[0];
var _y          = argument[1];
var _json       = argument[2];
var _colour     = ((argument_count < 4) || (argument[3]==undefined))? draw_get_colour() : argument[3];
var _alpha      = ((argument_count < 5) || (argument[4]==undefined))? draw_get_alpha()  : argument[4];
var _fade       = ((argument_count < 6) || (argument[5]==undefined))? 1                 : argument[5];
if ( _json < 0 ) exit;

var _hyperlinks        = _json[? "hyperlinks"        ];
var _hyperlink_regions = _json[? "hyperlink regions" ];
var _json_lines        = _json[? "lines"             ];

var _shader            = _json[? "shader"            ];
var _smoothness        = _json[? "shader smoothness" ];

var _max = 1;
if ( _json[? "shader fade" ] == E_SCRIBBLE_FADE.PER_CHAR ) {
    _max = _json[? "vbuff chars" ];
} else if ( _json[? "shader fade" ] == E_SCRIBBLE_FADE.PER_LINE ) {
    _max = ds_list_size( _json_lines );
}

s_shader_begin( _shader );
s_shader_uniform_f( "u_fTime"       , ( _max + _smoothness ) * _fade );
s_shader_uniform_f( "u_fMaxTime"    ,   _max + _smoothness );
s_shader_uniform_f( "u_fSmoothness" , _smoothness );
s_shader_uniform_f( "u_fRainbowTime", (current_time/1200) mod 1 );
s_shader_uniform_f( "u_vShakeTime"  , random_range( -1, 1 ), random_range( -1, 1 ) );
s_shader_uniform_f( "u_fWaveTime"   , current_time/1600 );
s_shader_rgba(      "u_vColour"     , _colour, _alpha );
    
    //Set up basic translation matrix
    var _matrix;
    _matrix[15] =  1;
    _matrix[ 0] =  1;
    _matrix[ 5] =  1;
    _matrix[10] =  1;
    _matrix[12] = _x + _json[? "left" ];
    _matrix[13] = _y + _json[? "top"  ];
    matrix_set( matrix_world, _matrix );
    
        vertex_submit( _json[? "vertex buffer" ], pr_trianglelist, global.scribble_texture );
    
    //Now reset the shader to a straight pass-through (in a really efficient way!)
    _matrix[12] = 0;
    _matrix[13] = 0;
    matrix_set( matrix_world, _matrix );

s_shader_end();



var _sprite_list = _json[? "vbuff sprites" ];
var _sprites_size = ds_list_size( _sprite_list );
for( var _i = 0; _i < _sprites_size; _i++ ) {
    
    var _sprite_map = _sprite_list[| _i ];
    var _sprite_x = _x + _sprite_map[? "x" ];
    var _sprite_y = _y + _sprite_map[? "y" ];
    
    draw_sprite( _sprite_map[? "sprite" ], -1, _sprite_x, _sprite_y );
    
}



var _regions = ds_list_size( _hyperlink_regions );
for( var _i = 0; _i < _regions; _i++ ) {
    
    var _region_map    = _hyperlink_regions[| _i ];
    var _hyperlink_map = _hyperlinks[? _region_map[? "hyperlink" ] ];
    var _region_line   = _region_map[? "line" ];
    var _region_word   = _region_map[? "word" ];
    
    var _line_map   = _json_lines[| _region_line ];
    var _words_list = _line_map[? "words" ];
    var _word_map   = _words_list[| _region_word ];
    
    var _region_x = _x + _line_map[? "x" ] + _word_map[? "x" ];
    var _region_y = _y + _line_map[? "y" ] + _word_map[? "y" ];
    
    if ( _hyperlink_map[? "down" ] ) {
        draw_rectangle( _region_x, _region_y, _region_x + _word_map[? "width" ], _region_y + _word_map[? "height" ], false );
    }
    
}