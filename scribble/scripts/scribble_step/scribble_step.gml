/// @description Handles mouse clicks for a SCRIBBLE JSON
///
/// April 2017
/// Juju Adams
/// julian.adams@email.com
/// @jujuadams
///
/// This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
/// https://creativecommons.org/licenses/by-nc-sa/4.0/
///
/// @param  x
/// @param  y
/// @param  json
/// @param  mouse x
/// @param  mouse y
/// @param  destroy if invisible

var _x       = argument0;
var _y       = argument1;
var _json    = argument2;
var _mouse_x = argument3;
var _mouse_y = argument4;
var _destroy = argument5;

if ( _json < 0 ) return noone;

if ( _json[? "transition state" ] == E_SCRIBBLE_STATE.INTRO ) {
    _json[? "transition timer" ] = clamp( _json[? "transition timer" ] + _json[? "intro speed" ], 0, _json[? "intro max" ] );
    if ( _json[? "transition timer" ] >= _json[? "intro max" ] ) _json[? "transition state" ] = E_SCRIBBLE_STATE.VISIBLE;
}

if ( _json[? "transition state" ] == E_SCRIBBLE_STATE.OUTRO ) {
    _json[? "transition timer" ] = clamp( _json[? "transition timer" ] - _json[? "outro speed" ], 0, _json[? "outro max" ] );
    if ( _json[? "transition timer" ] <= 0 ) _json[? "transition state" ] = E_SCRIBBLE_STATE.INVISIBLE;
}

var _text_limit        = _json[? "transition timer"  ];
var _text_font         = _json[? "default font"      ];
var _text_colour       = _json[? "default colour"    ];
var _hyperlinks        = _json[? "hyperlinks"        ];
var _hyperlink_regions = _json[? "hyperlink regions" ];
var _json_lines        = _json[? "lines"             ];

for( var _key = ds_map_find_first( _hyperlinks ); _key != undefined; _key = ds_map_find_next( _hyperlinks, _key ) ) {
    var _map = _hyperlinks[? _key ];
    _map[? "over" ] = false;
    _map[? "clicked" ] = false;
}

if ( _json[? "transition state" ] == E_SCRIBBLE_STATE.INVISIBLE ) {
    scribble_destroy( _json );
    return noone;
}

if ( _json[? "transition state" ] != E_SCRIBBLE_STATE.VISIBLE ) return _json;

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
    if ( _hyperlink_map != undefined ) && ( point_in_rectangle( _mouse_x, _mouse_y,
                                                                _region_x, _region_y,
                                                                _region_x + _word_map[? "width" ], _region_y + _word_map[? "height" ] ) ) {
        _hyperlink_map[? "over" ] = true;
    }
    
}

for( var _key = ds_map_find_first( _hyperlinks ); _key != undefined; _key = ds_map_find_next( _hyperlinks, _key ) ) {
    var _map = _hyperlinks[? _key ];
    if ( _map[? "over" ] ) {
        if ( mouse_check_button_pressed( mb_left ) ) {
            _map[? "down" ] = true;
        } else if ( !mouse_check_button( mb_left ) && _map[? "down" ] ) {
            _map[? "down" ] = false;
            _map[? "clicked" ] = true;
            if ( script_exists( _map[? "script" ] ) ) script_execute( _map[? "script" ] );
        }
    } else {
        _map[? "down" ] = false;
    }
}

return _json;
