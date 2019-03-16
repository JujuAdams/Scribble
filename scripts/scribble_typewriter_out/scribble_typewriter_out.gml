/// @param json
/// @param [speed]
/// @param [method]
/// @param [smoothness]

var _json       = argument[0];
var _speed      = (argument_count > 1)? argument[1] : undefined;
var _method     = (argument_count > 2)? argument[2] : undefined;
var _smoothness = (argument_count > 3)? argument[3] : SCRIBBLE_DEFAULT_TYPEWRITER_SMOOTHNESS;

if ( !is_real( _json ) || !ds_exists( _json, ds_type_list ) )
{
    show_error( "Scribble data structure \"" + string( _json ) + "\" doesn't exist!\n ", false );
    exit;
}

_json[| __E_SCRIBBLE.TW_DIRECTION ] = -1;
_json[| __E_SCRIBBLE.TW_POSITION  ] =  0;

if ( _speed      != undefined ) _json[| __E_SCRIBBLE.TW_SPEED      ] = _speed;
if ( _method     != undefined ) _json[| __E_SCRIBBLE.TW_METHOD     ] = _method;
if ( _smoothness != undefined ) _json[| __E_SCRIBBLE.TW_SMOOTHNESS ] = _smoothness;

switch( _json[| __E_SCRIBBLE.TW_METHOD ] )
{
    case SCRIBBLE_TYPEWRITER_WHOLE:
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        _json[| __E_SCRIBBLE.CHAR_FADE_T ] = 1;
        _json[| __E_SCRIBBLE.LINE_FADE_T ] = 1;
    break;
    
    default:
        show_error( "Typewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_WHOLE, SCRIBBLE_TYPEWRITER_PER_CHARACTER, or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false );
    break;
}