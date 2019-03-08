/// @description Text typewriter-ing
///
/// @param json
/// @param [do_typewriter]

var _json          = argument[0];
var _do_typewriter = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : true;

global.__scribble_host_destroyed = false;

//Clear this JSON's events state
ds_list_clear( _json[? "events triggered list" ] );
ds_map_clear(  _json[? "events triggered map"  ] );
ds_map_clear(  _json[? "events changed map"    ] );
ds_map_clear(  _json[? "events different map"  ] );

if ( _do_typewriter )
{
    var _tw_speed = _json[? "typewriter speed"    ];
    var _tw_pos   = _json[? "typewriter position" ];
    
    _tw_pos = scribble_events_scan_range( _json, _tw_pos, _tw_pos + _tw_speed );
    _tw_pos = min( _tw_pos, _json[? "length" ] );
    scribble_set_char_fade_in( _json, _tw_pos );
    
    _json[? "typewriter position" ] = _tw_pos;
}

return _json;