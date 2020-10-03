/// Draws text using Scribble's formatting.
/// 
/// Returns: A Scribble text element (which is really a complex array)
/// @param x                    x-position in the room to draw at.
/// @param y                    y-position in the room to draw at.
/// @param string/textElement   Either a string to be drawn, or a previously created text element
/// @param [occurrenceName]      Unique identifier to differentiate particular occurrences of a string within the game
/// 
/// Formatting commands:
/// [/]                                 Reset formatting to the starting format, as set by scribble_set_starting_format(). For legacy reasons, [] is also accepted
/// [/page]                             Page break
/// [delay]                             Pause the autotype for a fixed amount of time at the tag's position. Only supported when using autotype. DUration is defined by SCRIBBLE_DEFAULT_DELAY_DURATION
/// [delay,<time>]                      Pause the autotype for a fixed amount of time at the tag's position. Only supported when using autotype
/// [pause]                             Pause the autotype at the tag's position. Call scribble_autotype_is_paused() to unpause the autotyper. User scribble_autotype_is_paused() to return if the autotyper is paused
/// [<name of colour>]                  Set colour to one previously defined via scribble_add_color()
/// [#<hex code>]                       Set colour via a hexcode, using the industry standard 24-bit RGB format (#RRGGBB)
/// [d#<decimal>]                       Set colour via a decimal integer, using GameMaker's BGR format
/// [/colour] [/color] [/c]             Reset colour to the default
/// [<name of font>] [/font] [/f]       Set font / Reset font
/// [<name of sprite>]                  Insert an animated sprite starting on image 0 and animating using SCRIBBLE_DEFAULT_SPRITE_SPEED
/// [<name of sprite>,<image>]          Insert a static sprite using the specified image index
/// [<name of sprite>,<image>,<speed>]  Insert animated sprite using the specified image index and animation speed
/// [fa_left]                           Align horizontally to the left. This will insert a line break if used in the middle of a line of text
/// [fa_right]                          Align horizontally to the right. This will insert a line break if used in the middle of a line of text
/// [fa_center] [fa_centre]             Align centrally. This will insert a line break if used in the middle of a line of text
/// [scale,<factor>] [/scale] [/s]      Scale text / Reset scale to x1
/// [slant] [/slant]                    Set/unset italic emulation
/// [<event name>,<arg0>,<arg1>...]     Execute a script bound to an event name,previously defined using scribble_add_event(), with the specified arguments
/// [<effect name>] [/<effect name>]    Set/unset an effect
/// 
/// Scribble has the following animated effects by default:
/// [wave]    [/wave]                   Set/unset text to wave up and down
/// [shake]   [/shake]                  Set/unset text to shake
/// [rainbow] [/rainbow]                Set/unset text to cycle through rainbow colours
/// [wobble]  [/wobble]                 Set/unset text to wobble by rotating back and forth
/// [pulse]   [/pulse]                  Set/unset text to shrink and grow rhythmically
/// [wheel]   [/wheel]                  Set/unset text to circulate around their origin

function scribble_draw()
{
	var _draw_x         = argument[0];
	var _draw_y         = argument[1];
	var _draw_string    = argument[2];
	var _occurrence_name = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;

	//Check the cache
	var _scribble_array = scribble_cache(_draw_string, _occurrence_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurrence data
	var _occurrences_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
	var _occurrence_array = _occurrences_map[? _occurrence_name];

	//Find our page data
	var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
	var _page_array = _element_pages_array[_occurrence_array[__SCRIBBLE_OCCURRENCE.PAGE]];
    
	//Handle the animation timer
	var _increment_timers = ((current_time - _occurrence_array[__SCRIBBLE_OCCURRENCE.DRAWN_TIME]) > __SCRIBBLE_EXPECTED_FRAME_TIME);
	var _animation_time   = _occurrence_array[__SCRIBBLE_OCCURRENCE.ANIMATION_TIME];
    
	if (_increment_timers)
	{
	    _animation_time += SCRIBBLE_STEP_SIZE;
	    _occurrence_array[@ __SCRIBBLE_OCCURRENCE.ANIMATION_TIME] = _animation_time;
	}

	//Update when this text element was last drawn
	_scribble_array[@ SCRIBBLE.DRAWN_TIME] = current_time;
	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.DRAWN_TIME] = current_time;

	//Grab our vertex buffers for this page
	var _page_vbuffs_array = _page_array[__SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY];
	var _count = array_length(_page_vbuffs_array);
	if (_count > 0)
	{
	}
    
	return _scribble_array;
}