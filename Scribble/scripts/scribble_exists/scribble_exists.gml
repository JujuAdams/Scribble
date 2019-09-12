/// Returns whether a Scribble data structure exists.
/// 
/// This script is only meant to be called directly by advanced users. Please read the documentation carefully!
/// 
/// 
/// @param scribbleArray   The Scribble data structure to check the existence of.

var _scribble_array = argument0;

if (!is_array(_scribble_array)) return false;
if (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE) return false;
if (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION) return false;
if (_scribble_array[__SCRIBBLE.FREED]) return false;

return true;