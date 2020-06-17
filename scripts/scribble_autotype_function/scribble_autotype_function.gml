/// @param textElement        Text element to target
/// @param callbackFunction   Function to execute whenever a character is revealed
/// @param [occuranceName]    Unique identifier to differentiate particular occurances of a string within the game

function scribble_autotype_function()
{
	var _scribble_array = argument[0];
	var _function       = argument[1];
	var _occurance_name = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_OCCURANCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurance_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurance data
	var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
	var _occurance_array = _occurance_map[? _occurance_name];

	_occurance_array[@ __SCRIBBLE_OCCURANCE.FUNCTION] = _function;
}