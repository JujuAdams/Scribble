/// Returns an array of data that reflects the current draw state of Scribble.
/// This can be used to debug code, or used in combination with scribble_set_state() to create template draw states.

var _array = array_create(SCRIBBLE_STATE.__SIZE);
_array[@ SCRIBBLE_STATE.XSCALE             ] = global.scribble_state_xscale;
_array[@ SCRIBBLE_STATE.YSCALE             ] = global.scribble_state_yscale;
_array[@ SCRIBBLE_STATE.ANGLE              ] = global.scribble_state_angle;
_array[@ SCRIBBLE_STATE.COLOUR             ] = global.scribble_state_colour;
_array[@ SCRIBBLE_STATE.ALPHA              ] = global.scribble_state_alpha;
_array[@ SCRIBBLE_STATE.LINE_MIN_HEIGHT    ] = global.scribble_state_line_min_height;
_array[@ SCRIBBLE_STATE.MAX_WIDTH          ] = global.scribble_state_max_width;
_array[@ SCRIBBLE_STATE.MAX_HEIGHT         ] = global.scribble_state_max_height;
_array[@ SCRIBBLE_STATE.CHARACTER_WRAP     ] = global.scribble_state_character_wrap;
_array[@ SCRIBBLE_STATE.HALIGN             ] = global.scribble_state_box_halign;
_array[@ SCRIBBLE_STATE.VALIGN             ] = global.scribble_state_box_valign;
_array[@ SCRIBBLE_STATE.AUTOTYPE_FADE_IN   ] = global.scribble_state_tw_fade_in;
_array[@ SCRIBBLE_STATE.AUTOTYPE_POSITION  ] = global.scribble_state_tw_position;
_array[@ SCRIBBLE_STATE.AUTOTYPE_METHOD    ] = global.scribble_state_tw_method;
_array[@ SCRIBBLE_STATE.AUTOTYPE_SMOOTHNESS] = global.scribble_state_tw_smoothness;
_array[@ SCRIBBLE_STATE.ANIMATION_ARRAY    ] = global.scribble_state_anim_array;
_array[@ SCRIBBLE_STATE.CACHE_GROUP        ] = global.scribble_state_cache_group;
_array[@ SCRIBBLE_STATE.ALLOW_DRAW         ] = global.scribble_state_allow_draw;
_array[@ SCRIBBLE_STATE.FREEZE             ] = global.scribble_state_freeze;
return _array;