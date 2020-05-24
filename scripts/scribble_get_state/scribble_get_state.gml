/// Returns: Array that contains the current Scribble draw state
/// This function is intended to be used in combination with scribble_set_state()

var _array = array_create(SCRIBBLE_STATE.__SIZE);
_array[@ SCRIBBLE_STATE.DEFAULT_FONT   ] = global.scribble_state_default_font;
_array[@ SCRIBBLE_STATE.DEFAULT_COLOR  ] = global.scribble_state_default_color;
_array[@ SCRIBBLE_STATE.DEFAULT_HALIGN ] = global.scribble_state_default_halign;
_array[@ SCRIBBLE_STATE.XSCALE         ] = global.scribble_state_xscale;
_array[@ SCRIBBLE_STATE.YSCALE         ] = global.scribble_state_yscale;
_array[@ SCRIBBLE_STATE.ANGLE          ] = global.scribble_state_angle;
_array[@ SCRIBBLE_STATE.COLOUR         ] = global.scribble_state_colour;
_array[@ SCRIBBLE_STATE.ALPHA          ] = global.scribble_state_alpha;
_array[@ SCRIBBLE_STATE.LINE_MIN_HEIGHT] = global.scribble_state_line_min_height;
_array[@ SCRIBBLE_STATE.LINE_MAX_HEIGHT] = global.scribble_state_line_max_height;
_array[@ SCRIBBLE_STATE.MAX_WIDTH      ] = global.scribble_state_max_width;
_array[@ SCRIBBLE_STATE.MAX_HEIGHT     ] = global.scribble_state_max_height;
_array[@ SCRIBBLE_STATE.CHARACTER_WRAP ] = global.scribble_state_character_wrap;
_array[@ SCRIBBLE_STATE.BOX_HALIGN     ] = global.scribble_state_box_halign;
_array[@ SCRIBBLE_STATE.BOX_VALIGN     ] = global.scribble_state_box_valign;
_array[@ SCRIBBLE_STATE.ANIMATION_ARRAY] = global.scribble_state_anim_array; //TODO - Copy array?
return _array;