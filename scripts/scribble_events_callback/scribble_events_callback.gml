/// @param json
/// @param event_name
/// @param script
/// @param [event_name]
/// @param [script]

if ( SCRIBBLE_COMPATIBILITY_MODE ) exit;

var _json = argument[0];

var _triggered_list = _json[? "events triggered list" ];
var _value_map      = _json[? "events value map"      ];
var _changed_map    = _json[? "events changed map"    ];
var _different_map  = _json[? "events different map"  ];

var _triggered_count = ds_list_size( _triggered_list );
for( var _event = 0; _event < _triggered_count; _event++ ) {
    
    var _event_name = _triggered_list[| _event ];
    for( var _index = 1; _index < argument_count; _index += 2 ) {
        if ( _event_name == argument[_index] ) script_execute( argument[_index+1], _json, _value_map[? _event_name ], _changed_map[? _event_name ], _different_map[? _event_name ] );
    }
    
}