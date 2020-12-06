/// @param stateArray   Array of data that will be copied into Scribble's internal draw state
/// 
/// Updates Scribble's current draw state from an array. This function is intended to be used
/// in combination with scribble_get_state().

global.scribble_state_starting_font   = argument0[SCRIBBLE_STATE.STARTING_FONT  ];
global.scribble_state_starting_color  = argument0[SCRIBBLE_STATE.STARTING_COLOR ];
global.scribble_state_starting_halign = argument0[SCRIBBLE_STATE.STARTING_HALIGN];
global.scribble_state_xscale          = argument0[SCRIBBLE_STATE.XSCALE         ];
global.scribble_state_yscale          = argument0[SCRIBBLE_STATE.YSCALE         ];
global.scribble_state_angle           = argument0[SCRIBBLE_STATE.ANGLE          ];
global.scribble_state_colour          = argument0[SCRIBBLE_STATE.COLOUR         ];
global.scribble_state_alpha           = argument0[SCRIBBLE_STATE.ALPHA          ];
global.scribble_state_line_min_height = argument0[SCRIBBLE_STATE.LINE_MIN_HEIGHT];
global.scribble_state_line_max_height = argument0[SCRIBBLE_STATE.LINE_MAX_HEIGHT];
global.scribble_state_max_width       = argument0[SCRIBBLE_STATE.MAX_WIDTH      ];
global.scribble_state_max_height      = argument0[SCRIBBLE_STATE.MAX_HEIGHT     ];
global.scribble_state_character_wrap  = argument0[SCRIBBLE_STATE.CHARACTER_WRAP ];
global.scribble_state_box_halign      = argument0[SCRIBBLE_STATE.BOX_HALIGN     ];
global.scribble_state_box_valign      = argument0[SCRIBBLE_STATE.BOX_VALIGN     ];
global.scribble_state_box_align_page  = argument0[SCRIBBLE_STATE.BOX_ALIGN_PAGE ];

var _array = argument0[SCRIBBLE_STATE.ANIMATION_ARRAY];
if (is_array(_array))
{
    var _new_array = array_create(SCRIBBLE_ANIM.__SIZE);
    array_copy(_new_array, 0, _array, 0, SCRIBBLE_ANIM.__SIZE);
    global.scribble_state_anim_array = _new_array;
}

global.__scribble_cache_string = string(global.scribble_state_starting_font  ) + ":" +
                                 string(global.scribble_state_starting_color ) + ":" +
                                 string(global.scribble_state_starting_halign) + ":" +
                                 string(global.scribble_state_line_min_height) + ":" +
                                 string(global.scribble_state_line_max_height) + ":" +
                                 string(global.scribble_state_max_width      ) + ":" +
                                 string(global.scribble_state_max_height     ) + ":" +
                                 string(global.scribble_state_character_wrap );