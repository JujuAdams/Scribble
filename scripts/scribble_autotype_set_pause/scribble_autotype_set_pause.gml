/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param state                Value to set for the pause state, true or false
/// @param [occurrenceName]      Unique identifier to differentiate particular occurrences of a string within the game

function scribble_autotype_set_pause()
{
	var _scribble_array = argument[0];
	var _state          = argument[1];
	var _occurrence_name = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurrence_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurrence data
	var _occurrence_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
	var _occurrence_array = _occurrence_map[? _occurrence_name];

	if (_occurrence_array[__SCRIBBLE_OCCURRENCE.PAUSED] && !_state)
	{
	    var _typewriter_smoothness   = _occurrence_array[__SCRIBBLE_OCCURRENCE.SMOOTHNESS  ];
	    var _typewriter_window       = _occurrence_array[__SCRIBBLE_OCCURRENCE.WINDOW      ];
	    var _typewriter_window_array = _occurrence_array[__SCRIBBLE_OCCURRENCE.WINDOW_ARRAY];
    
	    //Increment the window index
	    var _old_head_pos = _typewriter_window_array[@ _typewriter_window];
	    _typewriter_window = (_typewriter_window + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
	    _occurrence_array[@ __SCRIBBLE_OCCURRENCE.WINDOW] = _typewriter_window;
	    _typewriter_window_array[@ _typewriter_window  ] = _old_head_pos;
	    _typewriter_window_array[@ _typewriter_window+1] = _old_head_pos - _typewriter_smoothness;
	}

	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.PAUSED] = _state;
}