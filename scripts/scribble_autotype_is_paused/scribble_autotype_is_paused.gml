/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param [occurrenceName]      Unique identifier to differentiate particular occurrences of a string within the game

function scribble_autotype_is_paused()
{
	var _scribble_array = argument[0];
	var _occurrence_name = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurrence_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurrence data
	var _occurrence_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
	var _occurrence_array = _occurrence_map[? _occurrence_name];

	return _occurrence_array[__SCRIBBLE_OCCURRENCE.PAUSED];
}