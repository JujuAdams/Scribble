/// @description Handles mouse clicks for a Scribble JSON
///
/// @param json
/// @param x
/// @param y
/// @param mouse_x
/// @param mouse_y

var _json          = argument[0];
var _x             = argument[1];
var _y             = argument[2];
var _mouse_x       = argument[3];
var _mouse_y       = argument[4];

#region Clear Event State
global.__scribble_host_destroyed = false;
scribble_events_clear( _json );
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