/// Returns: The width of the text element's bounding box, ignoring rotation and scaling
/// @param string/textElement   The text to get the bounding box for. Alternatively, you can pass a text element into this script
function scribble_get_width(argument0) {

	var _scribble_array = argument0;

	_scribble_array = scribble_cache(_scribble_array);
	if (_scribble_array == undefined) return 0;

	return _scribble_array[SCRIBBLE.WIDTH];


}
