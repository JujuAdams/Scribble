/// Returns: The text element's autotype state (see below)
/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param [occuranceName]      Unique identifier to differentiate particular occurances of a string within the game
/// 
/// The autotype state is a real value as follows:
///     state = 0   No text is visible
/// 0 < state < 1   Text is fading in. This value is the proportion of text that is visible e.g. 0.4 is 40% visibility
///     state = 1   Text is fully visible and the fade in animation has finished
/// 1 < state < 2   Text is fading out. 2 minus this value is the proportion of text that is visible e.g. 1.6 is 40% visibility
///     state = 2   No text is visible and the fade out animation has finished
/// 
/// If no autotype animation has been started, this function will return 1.

function scribble_autotype_get()
{
	var _scribble_array = argument[0];
	var _occurance_name = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_OCCURANCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurance_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurance data
	var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
	var _occurance_array = _occurance_map[? _occurance_name];

	//Early out if the method is NONE
	var _typewriter_method = _occurance_array[__SCRIBBLE_OCCURANCE.METHOD];
	if (_typewriter_method == 0) return 1; //No fade in/out set

	//Return an error code if the fade in state has not been set
	//(The fade in state is initialised as -1)
	var _typewriter_fade_in = _occurance_array[__SCRIBBLE_OCCURANCE.FADE_IN];
	if (_occurance_array[__SCRIBBLE_OCCURANCE.FADE_IN] < 0) return -2;

	var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
	var _page_array = _element_pages_array[_occurance_array[__SCRIBBLE_OCCURANCE.PAGE]];

	switch(_typewriter_method)
	{
	    case 1: //Per character
	        var _min = _page_array[__SCRIBBLE_PAGE.START_CHAR];
	        var _max = _page_array[__SCRIBBLE_PAGE.LAST_CHAR ];
            
            if (_max <= _min) return 1.0;
            _max += 2; //Bit of a hack
	    break;
    
	    case 2: //Per line
	        var _min = 0;
	        var _max = _page_array[__SCRIBBLE_PAGE.LINES];
	    break;
	}

	//Normalise the parameter from 0 -> 1 using the total counter
	var _window       = _occurance_array[__SCRIBBLE_OCCURANCE.WINDOW      ];
	var _window_array = _occurance_array[__SCRIBBLE_OCCURANCE.WINDOW_ARRAY];
	var _typewriter_t = clamp((_window_array[_window] - _min) / (_max - _min), 0, 1);

	//Add one if we're fading out
	return _typewriter_fade_in? _typewriter_t : (_typewriter_t+1);
}