/// @param textElement
/// @param [occuranceName]

var _scribble_array = argument[0];
var _occurance_name = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : global.__scribble_default_occurance_name;

//Check if this array is a relevant text element
if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != SCRIBBLE.__SIZE)
|| (_scribble_array[SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_autotype_is_paused() is not a valid Scribble text element");
    return false;
}

if (_scribble_array[SCRIBBLE.FREED]) return false;

//Find our occurance data
var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
var _occurance_array = _occurance_map[? _occurance_name];

return _occurance_array[__SCRIBBLE_OCCURANCE.PAUSED];