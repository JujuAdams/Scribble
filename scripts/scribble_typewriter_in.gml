/// void scribble_typewriter_in(json, [method], [speed], [smoothness]);
/// Begins a fade-in animation for a Scribble data structure, starting at 0% visible
///
/// This script sets a Scribble data structure to fade in progressively over time.
/// Please note that this immediately sets visibility of the text to 0%.
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
var _method     = undefined;
var _speed      = undefined;
var _smoothness = undefined;

switch (argument_count){
    case 4:
        if ( argument[3] != undefined ) _smoothness = argument[3];
    case 3:
        if ( argument[2] != undefined ) _speed = argument[2];
    case 2:
        if ( argument[1] != undefined ) _method = argument[1];
        break;
}

if ( !is_real( _json ) || !ds_exists( _json, ds_type_list ) ) {
    show_error( "Scribble data structure " + string( _json ) + " doesn't exist!", false );
    exit;
}

_json[| __E_SCRIBBLE.TW_DIRECTION ] = 1;
_json[| __E_SCRIBBLE.TW_POSITION  ] = 0;

if ( _speed      != undefined ) _json[| __E_SCRIBBLE.TW_SPEED      ] = _speed;
if ( _method     != undefined ) _json[| __E_SCRIBBLE.TW_METHOD     ] = _method;
if ( _smoothness != undefined ) _json[| __E_SCRIBBLE.TW_SMOOTHNESS ] = _smoothness;

switch( _json[| __E_SCRIBBLE.TW_METHOD ] ) {
    case SCRIBBLE_TYPEWRITER_WHOLE:
        _json[| __E_SCRIBBLE.CHAR_FADE_T ] = 1;
        _json[| __E_SCRIBBLE.LINE_FADE_T ] = 1;
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        _json[| __E_SCRIBBLE.CHAR_FADE_T ] = 0;
        _json[| __E_SCRIBBLE.LINE_FADE_T ] = 1;
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        _json[| __E_SCRIBBLE.CHAR_FADE_T ] = 1;
        _json[| __E_SCRIBBLE.LINE_FADE_T ] = 0;
    break;
    
    default:
        show_error( "Typewriter method not recognised. Please use SCRIBBLE_TYPEWRITER_WHOLE, SCRIBBLE_TYPEWRITER_PER_CHARACTER, or SCRIBBLE_TYPEWRITER_PER_LINE. ", false );
    break;
}
