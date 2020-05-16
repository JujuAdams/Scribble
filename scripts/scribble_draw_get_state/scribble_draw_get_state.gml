/// Returns: Array that contains the current Scribble draw state
/// This function is intended to be used in combination with scribble_draw_set_state().

var _array = array_create(SCRIBBLE_STATE.__SIZE);
_array[@ SCRIBBLE_STATE.XSCALE         ] = global.scribble_state_xscale;
_array[@ SCRIBBLE_STATE.YSCALE         ] = global.scribble_state_yscale;
_array[@ SCRIBBLE_STATE.ANGLE          ] = global.scribble_state_angle;
_array[@ SCRIBBLE_STATE.COLOUR         ] = global.scribble_state_colour;
_array[@ SCRIBBLE_STATE.ALPHA          ] = global.scribble_state_alpha;
_array[@ SCRIBBLE_STATE.LINE_MIN_HEIGHT] = global.scribble_state_line_min_height;
_array[@ SCRIBBLE_STATE.MAX_WIDTH      ] = global.scribble_state_max_width;
_array[@ SCRIBBLE_STATE.MAX_HEIGHT     ] = global.scribble_state_max_height;
_array[@ SCRIBBLE_STATE.CHARACTER_WRAP ] = global.scribble_state_character_wrap;
_array[@ SCRIBBLE_STATE.HALIGN         ] = global.scribble_state_box_halign;
_array[@ SCRIBBLE_STATE.VALIGN         ] = global.scribble_state_box_valign;
_array[@ SCRIBBLE_STATE.ANIMATION_ARRAY] = global.scribble_state_anim_array;
return _array;