/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param [occuranceName]      Unique identifier to differentiate particular occurances of a string within the game
/// 
/// This function will skip the fade in or fade out animation that has been started by scribble_autotype_fade_in() or scribble_autotype_fade_out().
/// 
/// If text was fading in, all remaining events will be executed.

var _scribble_array = argument[0];
var _occurance_name = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_OCCURANCE_NAME;

var _scribble_array = scribble_cache(_scribble_array, _occurance_name);
if (_scribble_array == undefined) return undefined;

//Find our occurance data
var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
var _occurance_array = _occurance_map[? _occurance_name];

var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
var _page_array = _element_pages_array[_occurance_array[__SCRIBBLE_OCCURANCE.PAGE]];

switch(_occurance_array[__SCRIBBLE_OCCURANCE.METHOD])
{
    case SCRIBBLE_AUTOTYPE_PER_CHARACTER: var _max = _page_array[__SCRIBBLE_PAGE.LAST_CHAR]; break;
    case SCRIBBLE_AUTOTYPE_PER_LINE:      var _max = _page_array[__SCRIBBLE_PAGE.LINES    ]; break;
}

_occurance_array[@ __SCRIBBLE_OCCURANCE.WINDOW      ] = 0;
_occurance_array[@ __SCRIBBLE_OCCURANCE.WINDOW_ARRAY] = array_create(2*__SCRIBBLE_WINDOW_COUNT, _max);
_occurance_array[@ __SCRIBBLE_OCCURANCE.SKIP        ] = true;

return _max;