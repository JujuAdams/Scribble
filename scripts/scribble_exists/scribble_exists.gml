/// @param scribbleArray

var _scribble_array = argument0;

if (!is_array(_scribble_array)) return false;
if (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE) return false;
if (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION) return false;

return true;