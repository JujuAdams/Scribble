/// @param json
/// @param character

var _json = argument0;
var _char = argument1;

var _events_char_list      = _json[? "events character list" ];
var _events_name_list      = _json[? "events name list"      ];
var _events_data_list      = _json[? "events data list"      ];
var _events_triggered_list = _json[? "events triggered list" ];
var _events_value_map      = _json[? "events value map"      ];
var _events_changed_map    = _json[? "events changed map"    ];
var _events_previous_map   = _json[? "events previous map"   ];
var _events_different_map  = _json[? "events different map"  ];

var _event_count = ds_list_size( _events_char_list );
for( var _event = 0; _event < _event_count; _event++ ) {
    
    if ( _events_char_list[| _event ] != _char ) continue;
    
    var _name      = _events_name_list[|   _event ];
    var _data      = _events_data_list[|   _event ];
    var _old_data  = _events_value_map[?    _name ];
    var _old_event = _events_previous_map[? _name ];
    
    ds_list_add( _events_triggered_list, _name );
    _events_value_map[?    _name ] = _data;
    _events_previous_map[? _name ] = _event;
        
    if ( _old_data == undefined ) {
        _events_changed_map[? _name ] = true;
    } else {
        _events_changed_map[? _name ] = !array_equals( _data, _old_data );
    }
        
    if ( _old_event == undefined ) {
        _events_different_map[? _name ] = true;
    } else {
        _events_different_map[? _name ] = _old_event != _event;
    }
        
    ++_event;
    
}