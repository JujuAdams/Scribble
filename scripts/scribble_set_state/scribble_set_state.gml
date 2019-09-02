/// @param [stateArray]

if (argument_count == 0)
{
    global.__scribble_state_xscale          = undefined;
    global.__scribble_state_yscale          = undefined;
    global.__scribble_state_angle           = undefined;
    global.__scribble_state_colour          = undefined;
    global.__scribble_state_alpha           = undefined;
    global.__scribble_state_line_min_height = undefined;
    global.__scribble_state_min_width       = undefined;
    global.__scribble_state_max_width       = undefined;
    global.__scribble_state_min_height      = undefined;
    global.__scribble_state_max_height      = undefined;
    global.__scribble_state_box_halign      = undefined;
    global.__scribble_state_box_valign      = undefined;
    global.__scribble_state_tw_fade_in      = undefined;
    global.__scribble_state_tw_method       = undefined;
    global.__scribble_state_tw_speed        = undefined;
    global.__scribble_state_tw_smoothness   = undefined;
    global.__scribble_state_anim_array      = undefined;
}
else
{
    var _array = argument[0];
    global.__scribble_state_xscale          = _array[SCRIBBLE_STATE.XSCALE               ];
    global.__scribble_state_yscale          = _array[SCRIBBLE_STATE.YSCALE               ];
    global.__scribble_state_angle           = _array[SCRIBBLE_STATE.ANGLE                ];
    global.__scribble_state_colour          = _array[SCRIBBLE_STATE.COLOUR               ];
    global.__scribble_state_alpha           = _array[SCRIBBLE_STATE.ALPHA                ];
    global.__scribble_state_line_min_height = _array[SCRIBBLE_STATE.LINE_MIN_HEIGHT      ];
    global.__scribble_state_min_width       = _array[SCRIBBLE_STATE.MIN_WIDTH            ];
    global.__scribble_state_max_width       = _array[SCRIBBLE_STATE.MAX_WIDTH            ];
    global.__scribble_state_min_height      = _array[SCRIBBLE_STATE.MIN_HEIGHT           ];
    global.__scribble_state_max_height      = _array[SCRIBBLE_STATE.MAX_HEIGHT           ];
    global.__scribble_state_box_halign      = _array[SCRIBBLE_STATE.HALIGN               ];
    global.__scribble_state_box_valign      = _array[SCRIBBLE_STATE.VALIGN               ];
    global.__scribble_state_tw_fade_in      = _array[SCRIBBLE_STATE.TYPEWRITER_FADE_IN   ];
    global.__scribble_state_tw_method       = _array[SCRIBBLE_STATE.TYPEWRITER_METHOD    ];
    global.__scribble_state_tw_speed        = _array[SCRIBBLE_STATE.TYPEWRITER_SPEED     ];
    global.__scribble_state_tw_smoothness   = _array[SCRIBBLE_STATE.TYPEWRITER_SMOOTHNESS];
    global.__scribble_state_anim_array      = _array[SCRIBBLE_STATE.ANIMATION_ARRAY      ];
}