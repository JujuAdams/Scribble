/// Returns: Boolean; whether the page that is being drawn is the last page for the text element
/// 
/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw() or scribble_cache()
/// @param [occuranceName]      Unique identifier to differentiate particular occurances of a string within the game

function scribble_page_on_last()
{
	var _scribble_array = argument[0];
	var _occurance_name = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_OCCURANCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurance_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurance data
	var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
	var _occurance_array = _occurance_map[? _occurance_name];

	return (_occurance_array[__SCRIBBLE_OCCURANCE.PAGE] >= (_scribble_array[SCRIBBLE.PAGES]-1));
}