/// @description Handles sprite animation
///
/// @param json

var _json = argument0;

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

return _json;