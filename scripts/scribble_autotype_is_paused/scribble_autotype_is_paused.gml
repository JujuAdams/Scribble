/// @param textElement

var _scribble_array = argument0;

//Check if this array is a relevant text element
if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != SCRIBBLE.__SIZE)
|| (_scribble_array[SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_autotype_is_paused() is not a valid Scribble text element");
    return false;
}

if (_scribble_array[SCRIBBLE.FREED]) return false;

return _scribble_array[SCRIBBLE.AUTOTYPE_PAUSED];