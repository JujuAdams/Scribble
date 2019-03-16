/// something scribble_typewriter_get_state(json);
/// Returns the state of the typewriter effect for a Scribble data structure
///
/// A Scribble typewriter state is a decimal value from 0 to 2 (inclusive).
///
/// 0 = State      : Text not yet faded in
/// 0 < State < 1  : Text is fading in
/// 1 = State      : Text fully visible
/// 1 < State < 2  : Text is fading out
/// 2 = State      : Text fully faded out
///
/// You can start fade effects using scribble_typewriter_in() and scribble_typewriter_out().
///
/// @param json   The Scribble data structure to get the typewriter state from

var _json = argument0;

if ( !is_real( _json ) || !ds_exists( _json, ds_type_list ) ) {
    show_error( "Scribble data structure " + string( _json ) + " doesn't exist!", false );
    exit;
}

switch( _json[| __E_SCRIBBLE.TW_METHOD ] ) {
    case SCRIBBLE_TYPEWRITER_WHOLE:
        return ternary(_json[| __E_SCRIBBLE.TW_DIRECTION ] < 0, 1, 0) + _json[| __E_SCRIBBLE.TW_POSITION ];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        return _json[| __E_SCRIBBLE.CHAR_FADE_T ];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        return _json[| __E_SCRIBBLE.LINE_FADE_T ];
    break;
}

return undefined;
