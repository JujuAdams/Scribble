/// Begins a fade-in animation for a Scribble data structure, starting at 100% visible
///
/// This script sets a Scribble data structure to fade in progressively over time.
/// Please note that this immediately sets visibility of the text to 100%.
///
/// Three modes are supported:
/// 1) SCRIBBLE_TYPEWRITER_WHOLE         - Fades in the entire textbox at the same time
/// 2) SCRIBBLE_TYPEWRITER_PER_CHARACTER - Fades in the text one character at a time
/// 3) SCRIBBLE_TYPEWRITER_LINE          - Fades in the text one line at a time
///
/// @param json   The Scribble data structure to target

var _json = argument0;

if (!scribble_exists(_json))
{
    show_error("Scribble:\nScribble data structure \"" + string(_json) + "\" doesn't exist!\n ", false);
    exit;
}

_json[@ __SCRIBBLE.TW_DIRECTION] = -1;
_json[@ __SCRIBBLE.TW_POSITION ] =  0;

switch(_json[__SCRIBBLE.TW_METHOD])
{
    case SCRIBBLE_TYPEWRITER_WHOLE:
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        _json[@ __SCRIBBLE.CHAR_FADE_T] = 1;
        _json[@ __SCRIBBLE.LINE_FADE_T] = 1;
    break;
    
    default:
        show_error("Scribble:\nTypewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_WHOLE, SCRIBBLE_TYPEWRITER_PER_CHARACTER, or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false);
    break;
}