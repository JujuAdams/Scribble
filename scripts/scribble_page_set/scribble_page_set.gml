/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param page                 Page to display, starting at 0 for the first page
/// @param [occurrenceName]      Unique identifier to differentiate particular occurrences of a string within the game
/// 
/// This function is intended for use with scribble_page_get().
/// 
/// Please note that changing the page will reset any autotype animations i.e. those started by
/// scribble_autotype_fade_in() and scribble_autotype_fade_out().

function scribble_page_set()
{
	var _scribble_array = argument[0];
	var _page           = argument[1];
	var _occurrence_name = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurrence_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurrence data
	var _occurrence_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
	var _occurrence_array = _occurrence_map[? _occurrence_name];

	_page = clamp(_page, 0, _scribble_array[SCRIBBLE.PAGES]-1);
	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.PAGE] = _page;

	if (_occurrence_array[__SCRIBBLE_OCCURRENCE.METHOD] != 0)
	{
	    scribble_autotype_fade_in(_scribble_array,
	                              _occurrence_array[__SCRIBBLE_OCCURRENCE.SPEED     ],
	                              _occurrence_array[__SCRIBBLE_OCCURRENCE.SMOOTHNESS],
	                              _occurrence_array[__SCRIBBLE_OCCURRENCE.METHOD    ] == 2);
	}

	return _page;
}