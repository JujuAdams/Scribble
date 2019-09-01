/// Returns the state of the typewriter effect for a Scribble data structure
///
/// A Scribble typewriter state is a decimal value from 0 to 2 (inclusive).
///
///     State = 0  : Text not yet faded in, invisible
/// 0 < State < 1  : Text is fading in
///     State = 1  : Text fully visible
/// 1 < State < 2  : Text is fading out
///     State = 2  : Text fully faded out, invisible
///
/// You can start fade effects using scribble_typewriter_in() and scribble_typewriter_out().
///
/// @param scribbleArray   The Scribble data structure to get the typewriter state from

var _scribble_array = argument0;

if (!scribble_exists(_scribble_array))
{
    show_error("Scribble:\nScribble data structure \"" + string(_scribble_array) + "\" doesn't exist!\n ", false);
    exit;
}

switch(_scribble_array[__SCRIBBLE.TW_METHOD])
{
    case SCRIBBLE_TYPEWRITER_WHOLE:
        return ((_scribble_array[__SCRIBBLE.TW_DIRECTION] < 0)? 1 : 0) + _scribble_array[__SCRIBBLE.TW_POSITION];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        return _scribble_array[__SCRIBBLE.CHAR_FADE_T];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        return _scribble_array[__SCRIBBLE.LINE_FADE_T];
    break;
}

return undefined;