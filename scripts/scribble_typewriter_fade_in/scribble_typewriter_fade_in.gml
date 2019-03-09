/// @param json
/// @param [speed]
/// @param [method]
/// @param [smoothness]

var _json       = argument[0];
var _speed      = (argument_count > 1)? argument[1] : undefined;
var _method     = (argument_count > 2)? argument[2] : undefined;
var _smoothness = (argument_count > 3)? argument[3] : SCRIBBLE_DEFAULT_TYPEWRITER_SMOOTHNESS;

_json[? "typewriter direction" ] = 1;
_json[? "typewriter position"  ] = 0;

if ( _speed      != undefined ) _json[? "typewriter speed"      ] = _speed;
if ( _method     != undefined ) _json[? "typewriter method"     ] = _method;
if ( _smoothness != undefined ) _json[? "typewriter smoothness" ] = _smoothness;

switch( _json[? "typewriter method" ] )
{
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        _json[? "char fade t"          ] = 0;
        _json[? "char fade smoothness" ] = _json[? "typewriter smoothness" ] / _json[? "length" ];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        _json[? "line fade t"          ] = 0;
        _json[? "line fade smoothness" ] = _json[? "typewriter smoothness" ] / _json[? "lines" ];
    break;
    
    default:
        show_error( "Typewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_PER_CHARACTER or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false );
    break;
}