/// Resets Scribble's draw state to use pass-through values (usually inheriting defaults set in __scribble_config()).

global.__scribble_state_start_colour    = SCRIBBLE_DEFAULT_TEXT_COLOUR;
global.__scribble_state_start_font      = global.__scribble_default_font;
global.__scribble_state_start_halign    = SCRIBBLE_DEFAULT_HALIGN;
global.__scribble_state_xscale          = SCRIBBLE_DEFAULT_XSCALE;
global.__scribble_state_yscale          = SCRIBBLE_DEFAULT_YSCALE;
global.__scribble_state_angle           = SCRIBBLE_DEFAULT_ANGLE;
global.__scribble_state_colour          = SCRIBBLE_DEFAULT_BLEND_COLOUR;
global.__scribble_state_alpha           = SCRIBBLE_DEFAULT_ALPHA;
global.__scribble_state_line_min_height = undefined;
global.__scribble_state_min_width       = undefined;
global.__scribble_state_max_width       = undefined;
global.__scribble_state_min_height      = undefined;
global.__scribble_state_max_height      = undefined;
global.__scribble_state_box_halign      = SCRIBBLE_DEFAULT_BOX_HALIGN;
global.__scribble_state_box_valign      = SCRIBBLE_DEFAULT_BOX_VALIGN;
array_copy(global.__scribble_state_anim_array, 0, global.__scribble_default_anim_array, 0, SCRIBBLE_MAX_DATA_FIELDS);