/// @param textElement       Text element to target. This element must have been created previously by scribble_draw()
/// @param method            Typewriter method to use to fade out, either per-character or per-line. See below
/// @param speed             Amount of text to reveal per tick (1 tick is usually 1 frame). This is character or lines depending on the method defined above
/// @param smoothness        How much text fades in. Higher numbers will allow more text to be visible as it fades in
/// @param [occuranceName]
/// 
/// The method argument allows you to choose between two behaviours to fade out text. Most retro-styled games will likely want to use
/// SCRIBBLE_AUTOTYPE_PER_CHARACTER: this method will remove characters one by one like a typewriter. Modern text-heavy narrative games
/// may want to use SCRIBBLE_AUTOTYPE_PER_LINE instead.
/// 
/// How the text is revealed can be customised further by modifying the smoothness argument. A high value will cause text to be smoothly
/// faded out whereas a smoothness of 0 will cause text to instantly pop onto the screen. For advanced users, custom shader code can be
/// easily combined with the smoothness value to animate text as it fades out.
/// 
/// Events will not be executed as text fades out.

var _scribble_array = argument[0];
var _method         = argument[1];
var _speed          = argument[2];
var _smoothness     = argument[3];
var _occurance_name = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : global.__scribble_default_occurance_name;

//Check if this array is a relevant text element
if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != SCRIBBLE.__SIZE)
|| (_scribble_array[SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_autotype_fade_out() is not a valid Scribble text element.");
    exit;
}

if (_scribble_array[SCRIBBLE.FREED]) exit;

if ((_method != SCRIBBLE_AUTOTYPE_NONE)
&&  (_method != SCRIBBLE_AUTOTYPE_PER_CHARACTER)
&&  (_method != SCRIBBLE_AUTOTYPE_PER_LINE))
{
    show_error("Scribble:\nMethod not recognised.\nPlease use SCRIBBLE_AUTOTYPE_NONE, SCRIBBLE_AUTOTYPE_PER_CHARACTER, or SCRIBBLE_AUTOTYPE_PER_LINE.\n ", false);
    _method = SCRIBBLE_AUTOTYPE_NONE;
}

//Find our occurance data
var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
var _occurance_array = _occurance_map[? _occurance_name];

var _pages_array = _scribble_array[@ SCRIBBLE.PAGES_ARRAY];
var _page_array = _pages_array[_occurance_array[__SCRIBBLE_OCCURANCE.PAGE]];
var _window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, _page_array[__SCRIBBLE_PAGE.START_CHAR] - 1 - _smoothness);
_window_array[@ 0] += _smoothness;

//Update the remaining autotype state values
_occurance_array[@ __SCRIBBLE_OCCURANCE.WINDOW      ] = 0;
_occurance_array[@ __SCRIBBLE_OCCURANCE.WINDOW_ARRAY] = _window_array;
_occurance_array[@ __SCRIBBLE_OCCURANCE.METHOD      ] = _method;
_occurance_array[@ __SCRIBBLE_OCCURANCE.SPEED       ] = _speed;
_occurance_array[@ __SCRIBBLE_OCCURANCE.SMOOTHNESS  ] = _smoothness;
_occurance_array[@ __SCRIBBLE_OCCURANCE.FADE_IN     ] = false;
_occurance_array[@ __SCRIBBLE_OCCURANCE.SKIP        ] = false;