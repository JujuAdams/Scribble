/// @param json

var _json = argument0;

if (!is_array(_json)) return false;
if (array_length_1d(_json) != __SCRIBBLE.__SIZE) return false;
if (_json[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION) return false;

return true;