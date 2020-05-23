/// @param stateArray   Array of data that will be copied into Scribble's internal draw state
/// 
/// Updates Scribble's current draw state from an array. This function is intended to be used
/// in combination with scribble_draw_get_state().

global.scribble_state_default_font    = argument0[SCRIBBLE_STATE.DEFAULT_FONT   ];
global.scribble_state_default_color   = argument0[SCRIBBLE_STATE.DEFAULT_COLOR  ];
global.scribble_state_default_halign  = argument0[SCRIBBLE_STATE.DEFAULT_HALIGN ];
global.scribble_state_xscale          = argument0[SCRIBBLE_STATE.XSCALE         ];
global.scribble_state_yscale          = argument0[SCRIBBLE_STATE.YSCALE         ];
global.scribble_state_angle           = argument0[SCRIBBLE_STATE.ANGLE          ];
global.scribble_state_colour          = argument0[SCRIBBLE_STATE.COLOUR         ];
global.scribble_state_alpha           = argument0[SCRIBBLE_STATE.ALPHA          ];
global.scribble_state_line_min_height = argument0[SCRIBBLE_STATE.LINE_MIN_HEIGHT];
global.scribble_state_max_width       = argument0[SCRIBBLE_STATE.MAX_WIDTH      ];
global.scribble_state_max_height      = argument0[SCRIBBLE_STATE.MAX_HEIGHT     ];
global.scribble_state_character_wrap  = argument0[SCRIBBLE_STATE.CHARACTER_WRAP ];
global.scribble_state_box_halign      = argument0[SCRIBBLE_STATE.BOX_HALIGN     ];
global.scribble_state_box_valign      = argument0[SCRIBBLE_STATE.BOX_VALIGN     ];

//TODO - Array copy?
global.scribble_state_anim_array = argument0[SCRIBBLE_STATE.ANIMATION_ARRAY];

global.__scribble_cache_string = string(global.scribble_state_default_font   ) + ":" +
                                 string(global.scribble_state_default_color  ) + ":" +
                                 string(global.scribble_state_default_halign ) + ":" +
                                 string(global.scribble_state_line_min_height) + ":" +
                                 string(global.scribble_state_line_max_height) + ":" +
                                 string(global.scribble_state_max_width      ) + ":" +
                                 string(global.scribble_state_max_height     ) + ":" +
                                 string(global.scribble_state_character_wrap );