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

if (!is_array(_json))
{
    show_error("Scribble:\nScribble data structure \"" + string(_json) + "\" doesn't exist!\n ", false);
    exit;
}

switch(_json[ __SCRIBBLE.TW_METHOD ])
{
    case SCRIBBLE_TYPEWRITER_WHOLE:
        return ((_json[ __SCRIBBLE.TW_DIRECTION ] < 0)? 1 : 0) + _json[ __SCRIBBLE.TW_POSITION ];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        return _json[ __SCRIBBLE.CHAR_FADE_T ];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        return _json[ __SCRIBBLE.LINE_FADE_T ];
    break;
}

return undefined;