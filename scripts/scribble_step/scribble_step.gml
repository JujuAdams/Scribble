/// @description Handles mouse clicks for a Scribble JSON
///
/// @param json
/// @param x
/// @param y
/// @param mouse_x
/// @param mouse_y

var _json    = argument0;
var _x       = argument1;
var _y       = argument2;
var _mouse_x = argument3;
var _mouse_y = argument4;

#region Clear Event State
scribble_events_clear( _json );
#endregion

#region Animate Sprite Slots

var _sprite_slot_list = _json[? "sprite slots" ];
var _size = ds_list_size( _sprite_slot_list );
for( var _i = 0; _i < _size; _i++ ) {
    
    var _slot_map = _sprite_slot_list[| _i ];
    var _number   = _slot_map[? "frames" ];
    var _image    = _slot_map[? "image"  ];
    
    _image += _slot_map[? "speed" ];
    while ( _image <        0 ) _image += _number;
    while ( _image >= _number ) _image -= _number;
    
    _slot_map[? "image" ] = _image;
    
}

#endregion

#region Hyperlinks

var _json_lines         = _json[? "lines list" ];
var _hyperlinks         = _json[? "hyperlinks"              ];
var _hyperlink_regions  = _json[? "hyperlink regions"       ];
var _hyperlink_fade_in  = _json[? "hyperlink fade in rate"  ];
var _hyperlink_fade_out = _json[? "hyperlink fade out rate" ];

var _box_left = _json[? "left" ];
var _box_top  = _json[? "top"  ];

for( var _key = ds_map_find_first( _hyperlinks ); _key != undefined; _key = ds_map_find_next( _hyperlinks, _key ) ) {
    var _map = _hyperlinks[? _key ];
    _map[? "over" ] = false;
    _map[? "clicked" ] = false;
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
    
    var _region_x = _x + _line_map[? "x" ] + _word_map[? "x" ] + _box_left;
    var _region_y = _y + _line_map[? "y" ] + _word_map[? "y" ] + _box_top;
    if ( _hyperlink_map != undefined ) && ( point_in_rectangle( _mouse_x, _mouse_y,
                                                                _region_x, _region_y,
                                                                _region_x + _word_map[? "width" ], _region_y + _word_map[? "height" ] ) ) {
        _hyperlink_map[? "over" ] = true;
    }
    
}

for( var _key = ds_map_find_first( _hyperlinks ); _key != undefined; _key = ds_map_find_next( _hyperlinks, _key ) ) {
    
    var _map   = _hyperlinks[? _key ];
    var _index = _map[? "index" ];
    
    if ( _map[? "over" ] ) {
        
        if ( mouse_check_button_pressed( mb_left ) ) {
            _map[? "down" ] = true;
        } else if ( !mouse_check_button( mb_left ) && _map[? "down" ] ) {
            _map[? "down" ] = false;
            _map[? "clicked" ] = true;
            if ( script_exists( _map[? "script" ] ) ) script_execute( _map[? "script" ] );
        }
        
        _map[? "mix" ] = min( _map[? "mix" ] + _hyperlink_fade_in, 1 );
        
    } else {
        
        _map[? "down" ] = false;
        _map[? "mix" ] = max( _map[? "mix" ] - _hyperlink_fade_out, 0 );
        
    }
    
}

#endregion

return _json;