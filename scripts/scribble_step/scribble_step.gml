/// @description Text typewriter-ing
///
/// @param json

var _json = argument[0];

global.__scribble_host_destroyed = false;

//Clear this JSON's events state
ds_list_clear( _json[? "events triggered list" ] );
ds_map_clear(  _json[? "events triggered map"  ] );
ds_map_clear(  _json[? "events changed map"    ] );
ds_map_clear(  _json[? "events different map"  ] );

if ( _json[? "typewriter do" ] )
{
    var _tw_pos   = _json[? "typewriter position" ];
    var _tw_speed = _json[? "typewriter speed"    ];
    
    var _do_event_scan = true;
    var _scan_range_a = _tw_pos;
    var _scan_range_b = _tw_pos + _tw_speed;
    
    #region Advance typewriter
    
    switch( _json[? "typewriter method" ] )
    {
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            _tw_pos += _tw_speed;
            _tw_pos = min( _tw_pos, _json[? "length" ] );
            scribble_set_char_fade_in( _json, _tw_pos );
            _json[? "typewriter position" ] = _tw_pos;
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            _do_event_scan = false;
            
            _tw_pos += _tw_speed;
            _tw_pos = min( _tw_pos, _json[? "lines" ] );
            scribble_set_line_fade_in( _json, _tw_pos );
            _json[? "typewriter position" ] = _tw_pos;
        break;
        
        default:
            show_error( "Typewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_PER_CHARACTER or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false );
            _do_event_scan = false;
        break;
    }
    
    #endregion
}

return _json;