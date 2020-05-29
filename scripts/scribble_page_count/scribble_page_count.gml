/// Returns: Total number of pages for the text element
/// @param string/textElement  Text element to target. This element must have been created previously by scribble_draw()

var _scribble_array = argument0;

var _scribble_array = scribble_cache(_scribble_array);
if (_scribble_array == undefined) return undefined;

return _scribble_array[SCRIBBLE.PAGES];