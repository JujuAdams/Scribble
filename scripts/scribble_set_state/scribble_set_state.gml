/// @param stateArray   Array of data that will be copied into Scribble's internal draw state
/// 
/// Updates Scribble's current draw state from an array. This function is intended to be used
/// in combination with scribble_get_state().

function scribble_set_state(_state)
{
	global.scribble_state_starting_font   = _state[SCRIBBLE_STATE.STARTING_FONT      ];
	global.scribble_state_starting_color  = _state[SCRIBBLE_STATE.STARTING_COLOR     ];
	global.scribble_state_starting_halign = _state[SCRIBBLE_STATE.STARTING_HALIGN    ];
	global.scribble_state_xscale          = _state[SCRIBBLE_STATE.XSCALE             ];
	global.scribble_state_yscale          = _state[SCRIBBLE_STATE.YSCALE             ];
	global.scribble_state_angle           = _state[SCRIBBLE_STATE.ANGLE              ];
	global.scribble_state_colour          = _state[SCRIBBLE_STATE.COLOUR             ];
	global.scribble_state_alpha           = _state[SCRIBBLE_STATE.ALPHA              ];
	global.scribble_state_line_min_height = _state[SCRIBBLE_STATE.LINE_MIN_HEIGHT    ];
	global.scribble_state_line_max_height = _state[SCRIBBLE_STATE.LINE_MAX_HEIGHT    ];
	global.scribble_state_max_width       = _state[SCRIBBLE_STATE.MAX_WIDTH          ];
	global.scribble_state_max_height      = _state[SCRIBBLE_STATE.MAX_HEIGHT         ];
	global.scribble_state_character_wrap  = _state[SCRIBBLE_STATE.CHARACTER_WRAP     ];
	global.scribble_state_box_halign      = _state[SCRIBBLE_STATE.BOX_HALIGN         ];
	global.scribble_state_box_valign      = _state[SCRIBBLE_STATE.BOX_VALIGN         ];
    global.scribble_state_box_align_page  = _state[SCRIBBLE_STATE.BOX_ALIGN_PAGE     ];
    global.scribble_state_fog_colour      = _state[SCRIBBLE_STATE.FOG_COLOUR         ];
    global.scribble_state_fog_alpha       = _state[SCRIBBLE_STATE.FOG_BLEND          ];
    global.scribble_state_ignore_commands = _state[SCRIBBLE_STATE.IGNORE_COMMAND_TAGS];

	var _array = _state[SCRIBBLE_STATE.ANIMATION_ARRAY];
	if (is_array(_array))
	{
	    var _new_array = array_create(SCRIBBLE_ANIM.__SIZE);
	    array_copy(_new_array, 0, _array, 0, SCRIBBLE_ANIM.__SIZE);
	    global.scribble_state_anim_array = _new_array;
	}
}