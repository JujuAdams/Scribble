/// @param json
/// @param character_start
/// @param character_end
/// @param [block_0_char]

var _json       = argument[0];
var _char_start = argument[1];
var _char_end   = argument[2];
var _block_zero = ((argument_count>3) && (argument[3]!=undefined))? argument[3] : false;

var _events_char_list      = _json[? "events character list" ];
var _events_name_list      = _json[? "events name list"      ];
var _events_data_list      = _json[? "events data list"      ];
var _events_triggered_list = _json[? "events triggered list" ];
var _events_triggered_map  = _json[? "events triggered map"  ];
var _events_value_map      = _json[? "events value map"      ];
var _events_changed_map    = _json[? "events changed map"    ];
var _events_previous_map   = _json[? "events previous map"   ];
var _events_different_map  = _json[? "events different map"  ];

var _char_a = floor( _char_start );
var _char_b = floor( _char_end   );

var _event_count = ds_list_size( _events_char_list );

#region Check the 0th character for events if we're starting at 0
if ( !_block_zero && (_char_a == 0) )
{
    for( var _event = 0; _event < _event_count; _event++ )
    {
        if ( _events_char_list[| _event ] != _char ) continue;
        
        var _name      = _events_name_list[|   _event ];
        var _data      = _events_data_list[|   _event ];
        var _old_data  = _events_value_map[?    _name ];
        var _old_event = _events_previous_map[? _name ];
        
        ds_list_add( _events_triggered_list, _name );
        _events_value_map[?    _name ] = _data;
        _events_previous_map[? _name ] = _event;
        
        //Record whether this particular trigger contains different data to the last time this same event type was triggered
        _events_changed_map[? _name ] = (_old_data == undefined)? true : !array_equals( _data, _old_data );
        
        //Record whether this trigger is a different trigger to the last one (but may contain the same data)
        _events_different_map[? _name ] = (_old_event == undefined)? true : (_old_event != _event);
        
        ++_event;
    }
}
#endregion

//Scan through all our events until we find an event at a text position we haven't met yet
var _event = 0;
while (_event < _event_count) && (_events_char_list[| _event ] <= _char_a) ++_event;

//Now iterate from our current character position to the next character position
for( var _char = _char_a+1; _char <= _char_b; _char++ )
{
    var _name = "";
    
    while (_event < _event_count) && (_events_char_list[| _event ] <= _char)
    {
        var _name      = _events_name_list[|   _event ];
        var _data      = _events_data_list[|   _event ];
        var _old_data  = _events_value_map[?    _name ];
        var _old_event = _events_previous_map[? _name ];
    
        if ( !ds_map_exists( _events_triggered_map, _name ) )
        {
            ds_list_add( _events_triggered_list, _name );
            _events_triggered_map[? _name ] = true;
        }
        
        _events_value_map[?    _name ] = _data;
        _events_previous_map[? _name ] = _event;
        
        //Record whether this particular trigger contains different data to the last time this same event type was triggered
        _events_changed_map[? _name ] = (_old_data == undefined)? true : !array_equals( _data, _old_data );
        
        //Record whether this trigger is a different trigger to the last one (but may contain the same data)
        _events_different_map[? _name ] = (_old_event == undefined)? true : (_old_event != _event);
        
        ++_event;
        
        if ( _name == "break" ) || ( _name == "pause" ) break;
    }
    
    if ( _name == "break" ) || ( _name == "pause" )
    {
        _char_end = _char;
        break;
    }
}



#region Iterate over the list of triggered events and perform callback

var _triggered_count = ds_list_size( _events_triggered_list );
for( var _event = 0; _event < _triggered_count; _event++ )
{
    var _event_name = _events_triggered_list[| _event ];
    var _script = global.__scribble_events[? _event_name ];
    if ( _script != undefined ) script_execute( _script,
                                                _json,
                                                _events_value_map[?     _event_name ],
                                                _events_changed_map[?   _event_name ],
                                                _events_different_map[? _event_name ] );
}

#endregion



//Return the character position we got up to
return _char_end;