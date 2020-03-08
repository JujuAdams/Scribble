/// @param textElement

var _scribble_array = argument0;

//Check if this array is a relevant text element
if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
|| (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_autotype_skip() is not a valid Scribble text element.");
    exit;
}

if (_scribble_array[__SCRIBBLE.FREED]) exit;

var _element_pages_array = _scribble_array[__SCRIBBLE.PAGES_ARRAY];
var _page_array = _element_pages_array[_scribble_array[__SCRIBBLE.AUTOTYPE_PAGE]];

var _max = 1;
switch(_scribble_array[__SCRIBBLE.AUTOTYPE_METHOD])
{
    case SCRIBBLE_AUTOTYPE_PER_CHARACTER: var _max = _page_array[__SCRIBBLE_PAGE.CHARACTERS]; break;
    case SCRIBBLE_AUTOTYPE_PER_LINE:      var _max = _page_array[__SCRIBBLE_PAGE.LINES     ]; break;
}

_scribble_array[@ __SCRIBBLE.AUTOTYPE_POSITION] = _max + _scribble_array[__SCRIBBLE.AUTOTYPE_SMOOTHNESS];

return _max;