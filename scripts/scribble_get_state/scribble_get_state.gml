/// Returns: Array that contains the current Scribble draw state
///
/// @param [ignoreAnimation]   Set to <true> to not include animation state data in the returned array
///
/// This function is intended to be used in combination with scribble_set_state()

function scribble_get_state()
{
	var _ignore_animation = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : false;

	var _array = array_create(SCRIBBLE_STATE.__SIZE);
	_array[@ SCRIBBLE_STATE.STARTING_FONT      ] = global.scribble_state_starting_font;
	_array[@ SCRIBBLE_STATE.STARTING_COLOR     ] = global.scribble_state_starting_color;
	_array[@ SCRIBBLE_STATE.STARTING_HALIGN    ] = global.scribble_state_starting_halign;
	_array[@ SCRIBBLE_STATE.XSCALE             ] = global.scribble_state_xscale;
	_array[@ SCRIBBLE_STATE.YSCALE             ] = global.scribble_state_yscale;
	_array[@ SCRIBBLE_STATE.ANGLE              ] = global.scribble_state_angle;
	_array[@ SCRIBBLE_STATE.COLOUR             ] = global.scribble_state_colour;
	_array[@ SCRIBBLE_STATE.ALPHA              ] = global.scribble_state_alpha;
	_array[@ SCRIBBLE_STATE.LINE_MIN_HEIGHT    ] = global.scribble_state_line_min_height;
	_array[@ SCRIBBLE_STATE.LINE_MAX_HEIGHT    ] = global.scribble_state_line_max_height;
	_array[@ SCRIBBLE_STATE.MAX_WIDTH          ] = global.scribble_state_max_width;
	_array[@ SCRIBBLE_STATE.MAX_HEIGHT         ] = global.scribble_state_max_height;
	_array[@ SCRIBBLE_STATE.CHARACTER_WRAP     ] = global.scribble_state_character_wrap;
	_array[@ SCRIBBLE_STATE.BOX_HALIGN         ] = global.scribble_state_box_halign;
	_array[@ SCRIBBLE_STATE.BOX_VALIGN         ] = global.scribble_state_box_valign;
    _array[@ SCRIBBLE_STATE.BOX_ALIGN_PAGE     ] = global.scribble_state_box_align_page;
    _array[@ SCRIBBLE_STATE.FOG_COLOUR         ] = global.scribble_state_fog_colour;
    _array[@ SCRIBBLE_STATE.FOG_BLEND          ] = global.scribble_state_fog_alpha;
    _array[@ SCRIBBLE_STATE.IGNORE_COMMAND_TAGS] = global.scribble_state_ignore_commands;

	if (!_ignore_animation)
	{
	    var _new_array = array_create(SCRIBBLE_ANIM.__SIZE);
	    array_copy(_new_array, 0, global.scribble_state_anim_array, 0, SCRIBBLE_ANIM.__SIZE);
	    _array[@ SCRIBBLE_STATE.ANIMATION_ARRAY] = _new_array;
	}
	else
	{
	    _array[@ SCRIBBLE_STATE.ANIMATION_ARRAY] = undefined;
	}

	return _array;
}