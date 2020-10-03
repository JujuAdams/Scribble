/// @param textElement        Text element to target
/// @param callbackFunction   Function to execute whenever a character is revealed
/// @param [occurrenceName]    Unique identifier to differentiate particular occurrences of a string within the game

function scribble_autotype_function()
{
	var _scribble_array = argument[0];
	var _function       = argument[1];
	var _occurrence_name = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurrence_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurrence data
	var _occurrence_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
	var _occurrence_array = _occurrence_map[? _occurrence_name];

	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.FUNCTION] = _function;
}