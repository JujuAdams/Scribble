/// @param textElement

var _scribble_array = argument0;

var _typewriter_fade_in  = _scribble_array[__SCRIBBLE.AUTOTYPE_FADE_IN ];
var _typewriter_method   = _scribble_array[__SCRIBBLE.AUTOTYPE_METHOD  ];
var _typewriter_position = _scribble_array[__SCRIBBLE.AUTOTYPE_POSITION];
var _typewriter_speed    = _scribble_array[__SCRIBBLE.AUTOTYPE_SPEED   ]* SCRIBBLE_STEP_SIZE;

if ((_typewriter_fade_in >= 0) && (_typewriter_speed > 0))
{
    //Find the last character we need to scan
    switch(_typewriter_method)
    {
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            var _scan_b = ceil(_typewriter_position + _typewriter_speed);
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            var _list   = _scribble_array[__SCRIBBLE.LINE_LIST];
            var _line   = _list[| min(ceil(_typewriter_position + _typewriter_speed), _scribble_array[__SCRIBBLE.LINES]-1)];
            var _scan_b = _line[__SCRIBBLE_LINE.LAST_CHAR];
        break;
    }
    
    var _scan_a = _scribble_array[__SCRIBBLE.EVENT_CHAR_PREVIOUS];
    if (_scan_b > _scan_a)
    {
        var _event             = _scribble_array[__SCRIBBLE.EVENT_PREVIOUS  ];
        var _events_char_array = _scribble_array[__SCRIBBLE.EVENT_CHAR_ARRAY];
        var _events_name_array = _scribble_array[__SCRIBBLE.EVENT_NAME_ARRAY];
        var _events_data_array = _scribble_array[__SCRIBBLE.EVENT_DATA_ARRAY];
        var _event_count       = array_length_1d(_events_char_array);
        
        //Always start scanning at the next event
        ++_event;
        if (_event >= _event_count) exit;
        var _event_char = _events_char_array[_event];
        
        //Now iterate from our current character position to the next character position
        var _break = false;
        var _scan = _scan_a;
        repeat(_scan_b - _scan_a)
        {
            while ((_event < _event_count) && (_event_char == _scan))
            {
                var _script = global.__scribble_autotype_events[? _events_name_array[_event]];
                if (_script != undefined)
                {
                    _scribble_array[@ __SCRIBBLE.EVENT_PREVIOUS] = _event;
                    script_execute(_script, _scribble_array, _events_data_array[_event], _scan);
                }
                
                if (_scribble_array[__SCRIBBLE.AUTOTYPE_SPEED] <= 0.0)
                {
                    _break = true;
                    break;
                }
                
                ++_event;
                if (_event < _event_count) _event_char = _events_char_array[_event];
            }
            
            if (_break) break;
            ++_scan;
        }
        
        if (_break && (_typewriter_method == SCRIBBLE_TYPEWRITER_PER_CHARACTER)) _typewriter_position = _scan + 1;
        
        _scribble_array[@ __SCRIBBLE.EVENT_CHAR_PREVIOUS] = _scan;
    }
}