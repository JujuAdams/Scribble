/// Animates effects, advances the typewriter effect for a Scribble data structure, and executes events as they appear
///
/// @param json    The Scribble data structure to manipulate

var _json = argument0;

if ( !is_real(_json) || !ds_exists(_json, ds_type_list) )
{
    show_error("Scribble:\nScribble data structure \"" + string(_json) + "\" doesn't exist!\n ", false);
    exit;
}

if (_json[| __SCRIBBLE.EV_SCAN_DO ])
{
    _json[| __SCRIBBLE.EV_SCAN_DO ] = false;
    
    var _scan_range_a          = _json[| __SCRIBBLE.EV_SCAN_A         ];
    var _scan_range_b          = _json[| __SCRIBBLE.EV_SCAN_B         ];
    var _events_char_list      = _json[| __SCRIBBLE.EV_CHARACTER_LIST ];
    var _events_name_list      = _json[| __SCRIBBLE.EV_NAME_LIST      ];
    var _events_data_list      = _json[| __SCRIBBLE.EV_DATA_LIST      ];
    var _events_triggered_list = _json[| __SCRIBBLE.EV_TRIGGERED_LIST ];
    var _events_triggered_map  = _json[| __SCRIBBLE.EV_TRIGGERED_MAP  ];
    var _events_value_map      = _json[| __SCRIBBLE.EV_VALUE_MAP      ];
    var _events_changed_map    = _json[| __SCRIBBLE.EV_CHANGED_MAP    ];
    var _events_previous_map   = _json[| __SCRIBBLE.EV_PREVIOUS_MAP   ];
    var _events_different_map  = _json[| __SCRIBBLE.EV_DIFFERENT_MAP  ];
    
    _json[| __SCRIBBLE.EV_SCAN_A ] = _scan_range_b;
    
    //Clear this JSON's events state
    ds_list_clear(_events_triggered_list);
    ds_map_clear( _events_triggered_map );
    ds_map_clear( _events_changed_map   );
    ds_map_clear( _events_different_map );
        
    var _char_a = floor(_scan_range_a);
    var _char_b = floor(_scan_range_b);
        
    var _event_count = ds_list_size(_events_char_list);
        
    //Check the 0th character for events if we're starting at 0
    if (_char_a == 0)
    {
        for(var _event = 0; _event < _event_count; _event++)
        {
            if (_events_char_list[| _event ] != _char_a) continue;
                
            var _name      = _events_name_list[|   _event ];
            var _data      = _events_data_list[|   _event ];
            var _old_data  = _events_value_map[?    _name ];
            var _old_event = _events_previous_map[? _name ];
                
            ds_list_add(_events_triggered_list, _name);
            _events_value_map[?    _name ] = _data;
            _events_previous_map[? _name ] = _event;
                
            //Record whether this particular trigger contains different data to the last time this same event type was triggered
            _events_changed_map[? _name ] = (_old_data == undefined)? true : !array_equals(_data, _old_data);
                
            //Record whether this trigger is a different trigger to the last one (but may contain the same data)
            _events_different_map[? _name ] = (_old_event == undefined)? true : (_old_event != _event);
                
            ++_event;
        }
    }
        
    //Scan through all our events until we find an event at a text position we haven't met yet
    var _event = 0;
    while (_event < _event_count) && (_events_char_list[| _event ] <= _char_a) ++_event;
        
    //Now iterate from our current character position to the next character position
    for(var _char = _char_a+1; _char <= _char_b; _char++)
    {
        var _name = "";
            
        while (_event < _event_count) && (_events_char_list[| _event ] <= _char)
        {
            var _name      = _events_name_list[|   _event ];
            var _data      = _events_data_list[|   _event ];
            var _old_data  = _events_value_map[?    _name ];
            var _old_event = _events_previous_map[? _name ];
                
            if ( !ds_map_exists(_events_triggered_map, _name) )
            {
                ds_list_add(_events_triggered_list, _name);
                _events_triggered_map[? _name ] = true;
            }
                
            _events_value_map[?    _name ] = _data;
            _events_previous_map[? _name ] = _event;
                
            //Record whether this particular trigger contains different data to the last time this same event type was triggered
            _events_changed_map[? _name ] = (_old_data == undefined)? true : !array_equals(_data, _old_data);
                
            //Record whether this trigger is a different trigger to the last one (but may contain the same data)
            _events_different_map[? _name ] = (_old_event == undefined)? true : (_old_event != _event);
                
            ++_event;
                
            //if (_name == "break") || (_name == "pause") break;
        }
            
        //if (_name == "break") || (_name == "pause")
        //{
        //    _char_end = _char;
        //    break;
        //}
    }
        
    //Iterate over the list of triggered events and perform callback
    var _triggered_count = ds_list_size(_events_triggered_list);
    for(var _event = 0; _event < _triggered_count; _event++)
    {
        var _event_name = _events_triggered_list[| _event ];
        var _script = global.__scribble_events[? _event_name ];
        if (_script != undefined) script_execute(_script,
                                                 _json,
                                                 _events_value_map[?     _event_name ],
                                                 _events_changed_map[?   _event_name ],
                                                 _events_different_map[? _event_name ]);
    }
}