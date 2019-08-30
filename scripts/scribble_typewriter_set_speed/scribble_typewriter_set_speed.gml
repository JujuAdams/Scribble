/// @param scribbleArray   The Scribble data structure to target
/// @param speed           The speed of the fade effect

var _scribble_array = argument0;
var _speed          = argument1;

if (!scribble_exists(_scribble_array))
{
    show_error("Scribble:\nScribble data structure \"" + string(_scribble_array) + "\" doesn't exist!\n ", false);
    exit;
}

_scribble_array[@ __SCRIBBLE.TW_SPEED] = _speed;