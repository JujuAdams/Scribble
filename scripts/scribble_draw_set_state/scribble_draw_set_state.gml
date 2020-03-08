/// @param stateArray   The array of data that will be copied into Scribble's internal draw state.
/// 
/// 
/// Updates Scribble's current draw state from an array. Any value that is <undefined> will use the default value instead.
/// This can be used in combination with scribble_get_state() to create template draw states.

global.scribble_state_xscale          = argument0[SCRIBBLE_STATE.XSCALE             ];
global.scribble_state_yscale          = argument0[SCRIBBLE_STATE.YSCALE             ];
global.scribble_state_angle           = argument0[SCRIBBLE_STATE.ANGLE              ];
global.scribble_state_colour          = argument0[SCRIBBLE_STATE.COLOUR             ];
global.scribble_state_alpha           = argument0[SCRIBBLE_STATE.ALPHA              ];
global.scribble_state_line_min_height = argument0[SCRIBBLE_STATE.LINE_MIN_HEIGHT    ];
global.scribble_state_max_width       = argument0[SCRIBBLE_STATE.MAX_WIDTH          ];
global.scribble_state_max_height      = argument0[SCRIBBLE_STATE.MAX_HEIGHT         ];
global.scribble_state_character_wrap  = argument0[SCRIBBLE_STATE.CHARACTER_WRAP     ];
global.scribble_state_box_halign      = argument0[SCRIBBLE_STATE.HALIGN             ];
global.scribble_state_box_valign      = argument0[SCRIBBLE_STATE.VALIGN             ];
global.scribble_state_tw_fade_in      = argument0[SCRIBBLE_STATE.AUTOTYPE_FADE_IN   ];
global.scribble_state_tw_position     = argument0[SCRIBBLE_STATE.AUTOTYPE_POSITION  ];
global.scribble_state_tw_smoothness   = argument0[SCRIBBLE_STATE.AUTOTYPE_SMOOTHNESS];
global.scribble_state_tw_method       = argument0[SCRIBBLE_STATE.AUTOTYPE_METHOD    ];
global.scribble_state_anim_array      = argument0[SCRIBBLE_STATE.ANIMATION_ARRAY    ];
global.scribble_state_cache_group     = argument0[SCRIBBLE_STATE.CACHE_GROUP        ];
global.scribble_state_allow_draw      = argument0[SCRIBBLE_STATE.ALLOW_DRAW         ];
global.scribble_state_freeze          = argument0[SCRIBBLE_STATE.FREEZE             ];