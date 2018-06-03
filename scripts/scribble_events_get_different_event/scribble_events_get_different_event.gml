/// @param json
/// @param name

var _json = argument0;
var _name = argument1;

var _events_different_map = _json[? "events changed map" ];
var _different = _events_different_map[? _name ];

if ( _different == undefined ) return false;
return _different;