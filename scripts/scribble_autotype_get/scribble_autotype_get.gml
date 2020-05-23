/// Returns: The text element's autotype state (see below)
/// @param textElement   Text element to target. This element must have been created previously by scribble_draw()
/// 
/// The autotype state is a real value as follows:
///     state = 0   No text is visible
/// 0 < state < 1   Text is fading in. This value is the proportion of text that is visible e.g. 0.4 is 40% visibility
///     state = 1   Text is fully visible and the fade in animation has finished
/// 1 < state < 2   Text is fading out. 2 minus this value is the proportion of text that is visible e.g. 1.6 is 40% visibility
///     state = 2   No text is visible and the fade out animation has finished
/// 
/// If no autotype animation has been started, this function will return 1.

var _scribble_array = argument0;

//Check if this array is a relevant text element
if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
|| (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_autotype_get() is not a valid Scribble text element.");
    exit;
}

if (_scribble_array[__SCRIBBLE.FREED]) return 0;

//Early out if the method is NONE
var _typewriter_method = _scribble_array[__SCRIBBLE.AUTOTYPE_METHOD];
if (_typewriter_method == SCRIBBLE_AUTOTYPE_NONE) return 1;

//Return an error code if the fade in state has not been set
//(The fade in state is initialised as -1)
var _typewriter_fade_in = _scribble_array[__SCRIBBLE.AUTOTYPE_FADE_IN];
if (_scribble_array[__SCRIBBLE.AUTOTYPE_FADE_IN] < 0) return -2;

var _element_pages_array = _scribble_array[__SCRIBBLE.PAGES_ARRAY];
var _page_array = _element_pages_array[_scribble_array[__SCRIBBLE.AUTOTYPE_PAGE]];

switch(_typewriter_method)
{
    case SCRIBBLE_AUTOTYPE_PER_CHARACTER:
        var _min = _page_array[__SCRIBBLE_PAGE.START_CHAR];
        var _max = _page_array[__SCRIBBLE_PAGE.LAST_CHAR ];
    break;
    
    case SCRIBBLE_AUTOTYPE_PER_LINE:
        var _min = 0;
        var _max = _page_array[__SCRIBBLE_PAGE.LINES];
    break;
}

//Normalise the parameter from 0 -> 1 using the total counter
var _window       = _scribble_array[__SCRIBBLE.AUTOTYPE_WINDOW      ];
var _window_array = _scribble_array[__SCRIBBLE.AUTOTYPE_WINDOW_ARRAY];
var _typewriter_t = clamp((_window_array[2*_window] - _min) / (_max - _min), 0, 1);

//Add one if we're fading out
return _typewriter_fade_in? _typewriter_t : (_typewriter_t+1);