/// Animates effects, advances the typewriter effect for a Scribble data structure, and executes events as they appear
///
/// @param json         The Scribble data structure to manipulate
/// @param [stepSize]   The step size e.g. a delta time coefficient. Defaults to 1
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _json      = argument[0];
var _step_size = ((argument_count > 1) && (argument_count[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_STEP_SIZE;

if (!SCRIBBLE_CALL_STEP_IN_DRAW) _json[| __SCRIBBLE.HAS_CALLED_STEP] = true;

if ( !is_real(_json) || !ds_exists(_json, ds_type_list) )
{
    show_error("Scribble:\nScribble data structure \"" + string(_json) + "\" doesn't exist!\n ", false);
    exit;
}

_json[| __SCRIBBLE.ANIMATION_TIME] += _step_size;

var _tw_speed     = _json[| __SCRIBBLE.TW_SPEED    ]*_step_size;
var _tw_direction = _json[| __SCRIBBLE.TW_DIRECTION];
if ((_tw_direction != 0) && (_tw_speed > 0))
{
    #region Advance typewriter
    
    var _tw_method = _json[| __SCRIBBLE.TW_METHOD  ];
    var _tw_pos    = _json[| __SCRIBBLE.TW_POSITION];
    var _pos_max   = 1.0;
    var _scan_a    = -1;
    var _scan_b    = -1;
    
    switch(_tw_method)
    {
        case SCRIBBLE_TYPEWRITER_WHOLE:
            if ((_tw_direction > 0) && (floor(_tw_pos) < floor(_tw_pos + _tw_speed)))
            {
                _scan_b = _json[| __SCRIBBLE.LENGTH];
            }
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            _pos_max = _json[| __SCRIBBLE.LENGTH];
            
            if ((_tw_direction > 0) && (ceil(_tw_pos) < ceil(_tw_pos + _tw_speed)))
            {
                _scan_b = ceil(_tw_pos + _tw_speed);
            }
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            _pos_max = _json[| __SCRIBBLE.LINES];
            
            if ((_tw_direction > 0) && (ceil(_tw_pos) < ceil(_tw_pos + _tw_speed)))
            {
                var _list = _json[| __SCRIBBLE.LINE_LIST];
                var _line = _list[| min(ceil(_tw_pos + _tw_speed), _pos_max-1)];
                _scan_b = _line[ __SCRIBBLE_LINE.LAST_CHAR];
            }
        break;
        
        default:
            show_error("Scribble:\nTypewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_PER_CHARACTER or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false);
        break;
    }
    
    _tw_pos = clamp(_tw_pos + _tw_speed, 0, _pos_max);
    
    #endregion
    
    if (_scan_b >= 0)
    {
        var _scan_a = _json[| __SCRIBBLE.EVENT_CHAR_PREVIOUS];
        if (_scan_b > _scan_a)
        {
            #region Scan for new events
            
            var _event             = _json[| __SCRIBBLE.EVENT_PREVIOUS  ];
            var _events_char_array = _json[| __SCRIBBLE.EVENT_CHAR_ARRAY];
            var _events_name_array = _json[| __SCRIBBLE.EVENT_NAME_ARRAY];
            var _events_data_array = _json[| __SCRIBBLE.EVENT_DATA_ARRAY];
            var _event_count       = array_length_1d(_events_char_array);
            
            //Always start scanning at the next event
            ++_event;
            
            //Now iterate from our current character position to the next character position
            var _break = false;
            var _scan_char = _scan_a;
            repeat(_scan_b - _scan_a)
            {
                while ((_event < _event_count) && (_events_char_array[_event] == _scan_char + 1))
                {
                    var _script = global.__scribble_events[? _events_name_array[_event]];
                    if (_script != undefined)
                    {
                        _json[| __SCRIBBLE.EVENT_PREVIOUS] = _event;
                        script_execute(_script, _json, _events_data_array[_event], _scan_char);
                    }
                    
                    if (_json[| __SCRIBBLE.TW_SPEED] <= 0.0)
                    {
                        _break = true;
                        break;
                    }
                    
                    ++_event;
                }
                
                if (_break) break;
                ++_scan_char;
            }
            
            if (_break)
            {
                if (_tw_method == SCRIBBLE_TYPEWRITER_PER_CHARACTER) _tw_pos = _scan_char + 1;
            }
            
            _json[| __SCRIBBLE.EVENT_CHAR_PREVIOUS] = _scan_char;
            
            #endregion
        }
    }
    
    _json[| __SCRIBBLE.TW_POSITION] = _tw_pos;
    
    switch(_tw_method)
    {
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            _json[| __SCRIBBLE.CHAR_FADE_T] = ((_tw_direction < 0)? 1 : 0) + clamp(_tw_pos / _pos_max, 0, 1);
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            _json[| __SCRIBBLE.LINE_FADE_T] = ((_tw_direction < 0)? 1 : 0) + clamp(_tw_pos / _pos_max, 0, 1);
        break;
    }
}