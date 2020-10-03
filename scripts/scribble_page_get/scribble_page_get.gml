/// Returns: Page that is currently being drawn, starting at 0 for the first page
/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param [occurrenceName]      Unique identifier to differentiate particular occurrences of a string within the game
/// 
/// This function is intended for use with scribble_page_set().

function scribble_page_get()
{
	var _scribble_array = argument[0];
	var _occurrence_name = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurrence_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurrence data
	var _occurrence_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
	var _occurrence_array = _occurrence_map[? _occurrence_name];

	return _occurrence_array[__SCRIBBLE_OCCURRENCE.PAGE];
}