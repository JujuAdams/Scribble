/// Returns: The height of the text element's bounding box
/// @param string/textElement   The text to get the bounding box for. Alternatively, you can pass a text element into this script

var _scribble_array = argument0;

_scribble_array = scribble_cache(_scribble_array);
if (_scribble_array == undefined) return 0;

return _scribble_array[SCRIBBLE.HEIGHT];