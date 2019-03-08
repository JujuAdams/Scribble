/// @param json
/// @param [speed]
/// @param [method]
/// @param [position]

var _json     = argument[0];
var _speed    = (argument_count > 1)? argument[1] : undefined;
var _method   = (argument_count > 2)? argument[2] : undefined;
var _position = (argument_count > 3)? argument[3] : undefined;

_json[? "typewriter do" ] = true;

if ( _speed    != undefined ) _json[? "typewriter speed"    ] = _speed;
if ( _method   != undefined ) _json[? "typewriter method"   ] = _method;
if ( _position != undefined ) _json[? "typewriter position" ] = _position;

switch( _json[? "typewriter method" ] )
{
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER: scribble_set_char_fade_in( _json, _json[? "typewriter position" ] ); break;
    case SCRIBBLE_TYPEWRITER_PER_LINE:      scribble_set_line_fade_in( _json, _json[? "typewriter position" ] ); break;
    default:
        show_error( "Typewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_PER_CHARACTER or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false );
    break;
}