/// @param json
///
/// 0 = State      : Text not yet faded in
/// 0 < State < 1  : Text is fading in
/// 1 = State      : Text fully visible
/// 1 < State < 2  : Text is fading out
/// 2 = State      : Text fully faded out

var _json = argument0;

switch( _json[| __E_SCRIBBLE.TW_METHOD ] )
{
    case SCRIBBLE_TYPEWRITER_WHOLE:
        return ((_json[| __E_SCRIBBLE.TW_DIRECTION ] < 0)? 1 : 0) + _json[| __E_SCRIBBLE.TW_POSITION ];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        return _json[| __E_SCRIBBLE.CHAR_FADE_T ];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        return _json[| __E_SCRIBBLE.LINE_FADE_T ];
    break;
}

return undefined;