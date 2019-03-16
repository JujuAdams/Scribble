/// Begins a fade-in animation for a Scribble data structure, starting at 100% visible
///
/// This script sets a Scribble data structure to fade in progressively over time.
/// Please note that this immediately sets visibility of the text to 100%.
/// To advance the typewriter fade effect for a Scribble data structure, scribble_step() must be called.
///
/// Three modes are supported:
/// 1) SCRIBBLE_TYPEWRITER_WHOLE         - Fades in the entire textbox at the same time
/// 2) SCRIBBLE_TYPEWRITER_PER_CHARACTER - Fades in the text one character at a time
/// 3) SCRIBBLE_TYPEWRITER_LINE          - Fades in the text one line at a time
///
/// @param json           The Scribble data structure to target
/// @param [method]       The fade method to use. See description for more details. Defaults to "don't change this value"
/// @param [speed]        The speed of the fade in effect. Defaults to "don't change this value"
/// @param [smoothness]   The smoothness of the fade in effect. Defaults to "don't change this value"
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _json       = argument[0];
var _method     = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : undefined;
var _speed      = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : undefined;
var _smoothness = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : undefined;

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