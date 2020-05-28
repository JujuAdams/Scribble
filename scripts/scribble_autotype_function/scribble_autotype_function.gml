/// @param textElement        Text element to target
/// @param callbackFunction   Function to execute whenever a character is revealed
/// @param [occuranceName]    Unique identifier to differentiate particular occurances of a string within the game

var _scribble_array = argument[0];
var _function       = argument[1];
var _occurance_name = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_OCCURANCE_NAME;

//Check if this array is a relevant text element
if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != SCRIBBLE.__SIZE)
|| (_scribble_array[SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_autotype_set_pause() is not a valid Scribble text element");
    return false;
}

if (_scribble_array[SCRIBBLE.FREED]) return false;

//Find our occurance data
var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
var _occurance_array = _occurance_map[? _occurance_name];

_occurance_array[@ __SCRIBBLE_OCCURANCE.FUNCTION] = _function;