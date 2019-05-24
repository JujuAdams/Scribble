/// Animates effects, advances the typewriter effect for a Scribble data structure, and executes events as they appear
///
/// @param json   The Scribble data structure to manipulate

var _json = argument0;

if (!is_real(_json) || !ds_exists(_json, ds_type_list))
{
    show_error("Scribble:\nScribble data structure \"" + string(_json) + "\" doesn't exist!\n ", false);
    exit;
}

if (_json[| __SCRIBBLE.EV_SCAN_DO])
{
    _json[| __SCRIBBLE.EV_SCAN_DO] = false;
    
    var _scan_range_a      = _json[| __SCRIBBLE.EV_SCAN_A    ];
    var _scan_range_b      = _json[| __SCRIBBLE.EV_SCAN_B    ];
    var _events_char_array = _json[| __SCRIBBLE.EV_CHAR_ARRAY];
    var _events_name_array = _json[| __SCRIBBLE.EV_NAME_ARRAY];
    var _events_data_array = _json[| __SCRIBBLE.EV_DATA_ARRAY];
    
    _json[| __SCRIBBLE.EV_SCAN_A] = _scan_range_b;
        
    var _char_a = floor(_scan_range_a);
    var _char_b = floor(_scan_range_b);
        
    var _event_count = array_length_1d(_events_char_array);
        
    //Check the 0th character for events if we're starting at 0
    if (_scan_range_a == 0)
    {
        for(var _event = 0; _event < _event_count; _event++)
        {
            if (_events_char_array[_event] == 0)
            {
                var _name = _events_name_array[_event];
                var _data = _events_data_array[_event];
                
                var _script = global.__scribble_events[? _name];
                if (_script != undefined) script_execute(_script, _json, _data);
            }
        }
    }
        
    //Scan through all our events until we find an event at a text position we haven't met yet
    var _event = 0;
    while ((_event < _event_count) && (_events_char_array[_event] <= _char_a)) ++_event;
        
    //Now iterate from our current character position to the next character position
    for(var _char = _char_a+1; _char <= _char_b; _char++)
    {
        var _name = "";
            
        while ((_event < _event_count) && (_events_char_array[_event] <= _char))
        {
            var _name = _events_name_array[_event];
            var _data = _events_data_array[_event];
            
            var _script = global.__scribble_events[? _name];
            if (_script != undefined) script_execute(_script, _json, _data);
              
            ++_event;
                
            //if (_name == "break") || (_name == "pause") break;
        }
            
        //if (_name == "break") || (_name == "pause")
        //{
        //    _char_end = _char;
        //    break;
        //}
    }
}