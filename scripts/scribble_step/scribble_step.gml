/// Advances the typewriter effect for a Scribble data structure, and executes events as they appear
///
/// @param json         The Scribble data structure to manipulate
/// @param [stepSize]   The step size e.g. a delta time coefficient. Defaults to 1
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _json      = argument[0];
var _step_size = ((argument_count > 1) && (argument_count[1] != undefined))? argument[1] : 1;

if ( !is_real( _json ) || !ds_exists( _json, ds_type_list ) )
{
    show_error( "Scribble data structure \"" + string( _json ) + "\" doesn't exist!\n ", false );
    exit;
}

_json[| __E_SCRIBBLE.ANIMATION_TIME ] += _step_size;

var _typewriter_direction = _json[| __E_SCRIBBLE.TW_DIRECTION ];
if ( _typewriter_direction != 0 )
{
    var _do_event_scan = false;
    
    #region Advance typewriter
    
    var _tw_pos   = _json[| __E_SCRIBBLE.TW_POSITION ];
    var _tw_speed = _json[| __E_SCRIBBLE.TW_SPEED    ];
    _tw_speed *= _step_size;
    
    switch( _json[| __E_SCRIBBLE.TW_METHOD ] )
    {
        case SCRIBBLE_TYPEWRITER_WHOLE:
            _do_event_scan = false;
            
            if ( _typewriter_direction > 0 )
            {
                if ( floor(_tw_pos) < floor(_tw_pos + _tw_speed) )
                {
                    var _scan_range_a = 0;
                    var _scan_range_b = _json[| __E_SCRIBBLE.LENGTH ];
                    _do_event_scan = true;
                }
            }
            
            _tw_pos += _tw_speed;
            _tw_pos = clamp( _tw_pos, 0, 1 );
            _json[| __E_SCRIBBLE.TW_POSITION ] = _tw_pos;
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            if ( _typewriter_direction > 0 )
            {
                _do_event_scan = true;
                var _scan_range_a = _tw_pos;
                var _scan_range_b = _tw_pos + _tw_speed;
            }
            
            var _length = _json[| __E_SCRIBBLE.LENGTH ];
            _tw_pos += _tw_speed;
            _tw_pos = min( _tw_pos, _length );
            
            _json[| __E_SCRIBBLE.TW_POSITION ] = _tw_pos;
            _json[| __E_SCRIBBLE.CHAR_FADE_T ] = ((_typewriter_direction < 0)? 1 : 0) + clamp( _tw_pos / _length, 0, 1 );
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            var _lines = _json[| __E_SCRIBBLE.LINES ];
            
            if ( _typewriter_direction > 0 )
            {
                var _list = _json[| __E_SCRIBBLE.LINE_LIST ];
                if ( floor(_tw_pos) > floor(_tw_pos - _tw_speed) )
                {
                    var _line_a = _list[| floor( _tw_pos ) ];
                    var _line_b = _list[| min( floor( _tw_pos + _tw_speed ), _lines-1 ) ];
                    var _scan_range_a = _line_a[ __E_SCRIBBLE_LINE.FIRST_CHAR ];
                    var _scan_range_b = _line_b[ __E_SCRIBBLE_LINE.LAST_CHAR  ];
                    _do_event_scan = true;
                }
            }
            
            _tw_pos += _tw_speed;
            _tw_pos = min( _tw_pos, _lines );
            
            _json[| __E_SCRIBBLE.TW_POSITION ] = _tw_pos;
            _json[| __E_SCRIBBLE.LINE_FADE_T ] = ((_typewriter_direction < 0)? 1 : 0) + clamp( _tw_pos / _lines, 0, 1 );
        break;
        
        default:
            show_error( "Typewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_PER_CHARACTER or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false );
        break;
    }
    
    #endregion
    
    if ( _do_event_scan )
    {
        #region Scan for new events
        
        var _events_char_list      = _json[| __E_SCRIBBLE.EV_CHARACTER_LIST ];
        var _events_name_list      = _json[| __E_SCRIBBLE.EV_NAME_LIST      ];
        var _events_data_list      = _json[| __E_SCRIBBLE.EV_DATA_LIST      ];
        var _events_triggered_list = _json[| __E_SCRIBBLE.EV_TRIGGERED_LIST ];
        var _events_triggered_map  = _json[| __E_SCRIBBLE.EV_TRIGGERED_MAP  ];
        var _events_value_map      = _json[| __E_SCRIBBLE.EV_VALUE_MAP      ];
        var _events_changed_map    = _json[| __E_SCRIBBLE.EV_CHANGED_MAP    ];
        var _events_previous_map   = _json[| __E_SCRIBBLE.EV_PREVIOUS_MAP   ];
        var _events_different_map  = _json[| __E_SCRIBBLE.EV_DIFFERENT_MAP  ];
        
        //Clear this JSON's events state
        ds_list_clear( _events_triggered_list );
        ds_map_clear(  _events_triggered_map  );
        ds_map_clear(  _events_changed_map    );
        ds_map_clear(  _events_different_map  );
        
        var _char_a = floor( _scan_range_a );
        var _char_b = floor( _scan_range_b );
        
        var _event_count = ds_list_size( _events_char_list );
        
        #region Check the 0th character for events if we're starting at 0
        if ( _char_a == 0 )
        {
            for( var _event = 0; _event < _event_count; _event++ )
            {
                if ( _events_char_list[| _event ] != _char_a ) continue;
                
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
                
                //if ( _name == "break" ) || ( _name == "pause" ) break;
            }
            
            //if ( _name == "break" ) || ( _name == "pause" )
            //{
            //    _char_end = _char;
            //    break;
            //}
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
        
        #endregion
    }
}