/// @param scribbleArray   The Scribble data structure to be drawn

var _scribble_array = argument0;

if (!scribble_exists(_scribble_array))
{
    show_error("Scribble:\nScribble data structure \"" + string(_scribble_array) + "\" doesn't exist!\n ", false);
    exit;
}

vertex_freeze(_scribble_array[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER]);