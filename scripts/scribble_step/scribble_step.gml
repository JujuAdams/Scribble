/// @description Sprite animation and text typewriter-ing
///
/// @param json
/// @param [do_typewriter]

var _json          = argument[0];
var _do_typewriter = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : true;

#region Events

global.__scribble_host_destroyed = false;
scribble_events_clear( _json );

if ( _do_typewriter )
{
    var _tw_speed = _json[? "typewriter speed"    ];
    var _tw_pos   = _json[? "typewriter position" ];
    
    _tw_pos = scribble_events_scan_range( _json, _tw_pos, _tw_pos + _tw_speed );
    scribble_events_callback( _json,   "sound", oExample_handle_sound,   "portrait", oExample_handle_portrait );
    _tw_pos = min( _tw_pos, scribble_get_length( _json ) );
    scribble_set_char_fade_in( _json, _tw_pos );
    
    _json[? "typewriter position" ] = _tw_pos;
}

#endregion

#region Animate Sprite Slots

var _sprite_slot_list = _json[? "sprite slots" ];
var _size = ds_list_size( _sprite_slot_list );
for( var _i = 0; _i < _size; _i++ )
{
    var _slot_map = _sprite_slot_list[| _i ];
    var _number   = _slot_map[? "frames" ];
    var _image    = _slot_map[? "image"  ];
    
    _image += _slot_map[? "speed" ];
    while ( _image <        0 ) _image += _number;
    while ( _image >= _number ) _image -= _number;
    
    _slot_map[? "image" ] = _image;
}

#endregion

return _json;