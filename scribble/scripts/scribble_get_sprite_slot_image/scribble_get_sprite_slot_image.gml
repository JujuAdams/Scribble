/// @param json
/// @param sprite_slot

var _json        = argument0;
var _sprite_slot = argument1;

var _sprite_slot_list = _json[? "sprite slots" ];
var _slot_map = _sprite_slot_list[| _sprite_slot ];
return _slot_map[? "image" ];