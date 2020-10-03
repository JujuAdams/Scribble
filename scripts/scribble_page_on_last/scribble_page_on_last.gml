/// Returns: Boolean; whether the page that is being drawn is the last page for the text element
/// 
/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw() or scribble_cache()
/// @param [occurrenceName]      Unique identifier to differentiate particular occurrences of a string within the game

function scribble_page_on_last()
{
	var _scribble_array = argument[0];
	var _occurrence_name = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurrence_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurrence data
	var _occurrence_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
	var _occurrence_array = _occurrence_map[? _occurrence_name];

	return (_occurrence_array[__SCRIBBLE_OCCURRENCE.PAGE] >= (_scribble_array[SCRIBBLE.PAGES]-1));
}