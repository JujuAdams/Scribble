/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param state                Value to set for the pause state, true or false
/// @param [occuranceName]      Unique identifier to differentiate particular occurances of a string within the game

function scribble_autotype_set_pause()
{
	var _scribble_array = argument[0];
	var _state          = argument[1];
	var _occurance_name = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_OCCURANCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurance_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurance data
	var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
	var _occurance_array = _occurance_map[? _occurance_name];

	if (_occurance_array[__SCRIBBLE_OCCURANCE.PAUSED] && !_state)
	{
	    var _typewriter_smoothness   = _occurance_array[__SCRIBBLE_OCCURANCE.SMOOTHNESS  ];
	    var _typewriter_window       = _occurance_array[__SCRIBBLE_OCCURANCE.WINDOW      ];
	    var _typewriter_window_array = _occurance_array[__SCRIBBLE_OCCURANCE.WINDOW_ARRAY];
    
	    //Increment the window index
	    var _old_head_pos = _typewriter_window_array[@ _typewriter_window];
	    _typewriter_window = (_typewriter_window + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
	    _occurance_array[@ __SCRIBBLE_OCCURANCE.WINDOW] = _typewriter_window;
	    _typewriter_window_array[@ _typewriter_window  ] = _old_head_pos;
	    _typewriter_window_array[@ _typewriter_window+1] = _old_head_pos - _typewriter_smoothness;
	}

	_occurance_array[@ __SCRIBBLE_OCCURANCE.PAUSED] = _state;
}