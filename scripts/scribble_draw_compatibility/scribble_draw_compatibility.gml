/// @param json
/// @param [x]
/// @param [y]
/// @param [do_hyperlinks]
/// @param [do_sprite_slots]

var _json            = argument[0];
var _x               = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : 0;
var _y               = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 0;
var _do_hyperlinks   = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : true;
var _do_sprite_slots = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : true;

if ( _do_hyperlinks ) {
    //Build an array that describes the hyperlink mix state for each hyperlink
    //(The default max value is 16)
    var _mix_array = array_create( SCRIBBLE_MAX_HYPERLINKS, 0 );
    var _hyperlinks = _json[? "hyperlinks" ];
    var _hyperlink_list = _json[? "hyperlink list" ];
    var _size = min( SCRIBBLE_MAX_HYPERLINKS, ds_list_size( _hyperlink_list ) );
    for( var _i = 0; _i < _size; _i++ ) {
    
        var _hyperlink_name = _hyperlink_list[| _i ];
        var _hyperlink_map = _hyperlinks[? _hyperlink_name ];
        _mix_array[ _i ] = _hyperlink_map[? "mix" ];
    
    }
}

if ( _do_sprite_slots ) {
    var _sprite_slot_array = array_create( SCRIBBLE_MAX_SPRITE_SLOTS, 0 );
    var _sprite_slot_list = _json[? "sprite slots" ];
    var _size = ds_list_size( _sprite_slot_list );
    for( var _i = 0; _i < _size; _i++ ) {
        var _slot_map = _sprite_slot_list[| _i ];
        _sprite_slot_array[ _i ] = _slot_map[? "image" ];
    }
}



var _old_alpha = draw_get_alpha();
draw_set_alpha( _json[? "alpha" ] );

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

var _hyperlinks = _json[? "hyperlinks" ];
var _hyperlink_colour = _json[? "hyperlink colour" ];

var _text_root_list = _json[? "lines list" ];
var _lines_count = ds_list_size( _text_root_list );
for( var _line = 0; _line < _lines_count; _line++ ) {
    
    var _line_json = _text_root_list[| _line ];
    var _line_x = _line_json[? "x" ];
    var _line_y = _line_json[? "y" ];
    
    var _words_list = _line_json[? "words" ];
    var _words_count = ds_list_size( _words_list );
    for( var _word = 0; _word < _words_count; _word++ ) {
        
        var _word_map  = _words_list[| _word ];
        var _x         = _word_map[?      "x" ] + _line_x;
        var _y         = _word_map[?      "y" ] + _line_y;
        var _sprite    = _word_map[? "sprite" ];
        
        if ( _sprite >= 0 ) {
            
            var _sprite_slot = _word_map[? "sprite slot" ];
            _x -= sprite_get_xoffset( _sprite );
            _y -= sprite_get_yoffset( _sprite );
            
            if ( _sprite_slot == undefined ) {
                draw_sprite( _sprite, _word_map[? "image" ], _x, _y );
            } else {
                draw_sprite( _sprite, _sprite_slot_array[ _sprite_slot ], _x, _y );
            }
            
        } else {
            
            var _string    = _word_map[?    "string" ];
            var _font_name = _word_map[?      "font" ];
            var _colour    = _word_map[?    "colour" ];
            var _hyperlink = _word_map[? "hyperlink" ];
            
            if ( _hyperlink != "" ) {
                var _hyperlink_map = _hyperlinks[? _hyperlink ];
                var _hyperlink_mix = _hyperlink_map[? "mix" ];
                _colour = merge_colour( _colour, _hyperlink_colour, _hyperlink_mix );
            }
            
            var _font = asset_get_index( _font_name );
            if ( _font >= 0 ) && ( asset_get_type( _font_name ) == asset_font ) {
                draw_set_font( _font );
            } else {
                var _font = global.__scribble_sprite_font_map[? _font_name ];
                if ( _font != undefined ) draw_set_font( _font );
            }
            
            draw_set_colour( _colour );
            draw_text( _x, _y, _string );
            
        }
    }
}

draw_set_alpha( _old_alpha );
if ( _x != 0 ) || ( _y != 0 ) matrix_set( matrix_world, _old_matrix );