/// @param json
/// @param name

var _json = argument0;
var _name = argument1;

var _events_changed_map = _json[? "events changed map" ];
var _changed = _events_changed_map[? _name ];

if ( _changed == undefined ) return false;
return _changed;