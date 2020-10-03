/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param [occurrenceName]      Unique identifier to differentiate particular occurrences of a string within the game
/// 
/// This function will skip the fade in or fade out animation that has been started by scribble_autotype_fade_in() or scribble_autotype_fade_out().
/// 
/// If text was fading in, all remaining events will be executed.

function scribble_autotype_skip()
{
	var _scribble_array = argument[0];
	var _occurrence_name = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurrence_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurrence data
	var _occurrence_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
	var _occurrence_array = _occurrence_map[? _occurrence_name];

	var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
	var _page_array = _element_pages_array[_occurrence_array[__SCRIBBLE_OCCURRENCE.PAGE]];

	switch(_occurrence_array[__SCRIBBLE_OCCURRENCE.METHOD])
	{
	    case 1: var _max = _page_array[__SCRIBBLE_PAGE.LAST_CHAR] + 2; break; //Per character
	    case 2: var _max = _page_array[__SCRIBBLE_PAGE.LINES    ];     break; //Per line
        default: exit;
	}

	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.WINDOW      ] = 0;
	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.WINDOW_ARRAY] = array_create(2*__SCRIBBLE_WINDOW_COUNT, _max);
	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.SKIP        ] = true;

	return _max;
}