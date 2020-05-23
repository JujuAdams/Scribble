/// @param textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param state         Value to set for the pause state, true or false

var _scribble_array = argument0;
var _state          = argument1;

//Check if this array is a relevant text element
if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
|| (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_autotype_set_pause() is not a valid Scribble text element");
    return false;
}

if (_scribble_array[__SCRIBBLE.FREED]) return false;

var _old_state = _scribble_array[__SCRIBBLE.AUTOTYPE_PAUSED];
_scribble_array[@ __SCRIBBLE.AUTOTYPE_PAUSED] = _state;

if (_old_state && !_state)
{
    var _typewriter_smoothness   = _scribble_array[__SCRIBBLE.AUTOTYPE_SMOOTHNESS  ];
    var _typewriter_window       = _scribble_array[__SCRIBBLE.AUTOTYPE_WINDOW      ];
    var _typewriter_window_array = _scribble_array[__SCRIBBLE.AUTOTYPE_WINDOW_ARRAY];
    
    var _old_head_pos = _typewriter_window_array[@ 2*_typewriter_window];
    _typewriter_window = (_typewriter_window + 1) mod __SCRIBBLE_WINDOW_COUNT;
    _scribble_array[@ __SCRIBBLE.AUTOTYPE_WINDOW] = _typewriter_window;
    _typewriter_window_array[@ 2*_typewriter_window  ] = _old_head_pos;
    _typewriter_window_array[@ 2*_typewriter_window+1] = _old_head_pos - _typewriter_smoothness;
}