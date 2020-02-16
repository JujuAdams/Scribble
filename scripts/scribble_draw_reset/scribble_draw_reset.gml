/// Resets Scribble's draw state to use pass-through values, inheriting defaults set in __scribble_config().

global.scribble_state_xscale          = SCRIBBLE_DEFAULT_XSCALE;
global.scribble_state_yscale          = SCRIBBLE_DEFAULT_YSCALE;
global.scribble_state_angle           = SCRIBBLE_DEFAULT_ANGLE;
global.scribble_state_colour          = SCRIBBLE_DEFAULT_BLEND_COLOUR;
global.scribble_state_alpha           = SCRIBBLE_DEFAULT_BLEND_ALPHA;
global.scribble_state_line_min_height = SCRIBBLE_DEFAULT_LINE_MIN_HEIGHT;
global.scribble_state_max_width       = SCRIBBLE_DEFAULT_MAX_WIDTH;
global.scribble_state_max_height      = SCRIBBLE_DEFAULT_MAX_HEIGHT;
global.scribble_state_character_wrap  = false;
global.scribble_state_box_halign      = SCRIBBLE_DEFAULT_BOX_HALIGN;
global.scribble_state_box_valign      = SCRIBBLE_DEFAULT_BOX_VALIGN;
global.scribble_state_tw_fade_in      = true;
global.scribble_state_tw_position     = 1;
global.scribble_state_tw_smoothness   = 0;
global.scribble_state_tw_method       = SCRIBBLE_AUTOTYPE_NONE;
global.scribble_state_cache_group     = SCRIBBLE_DEFAULT_CACHE_GROUP;
global.scribble_state_allow_draw      = true;
global.scribble_state_freeze          = false;
array_copy(global.scribble_state_anim_array, 0, global.__scribble_default_anim_array, 0, SCRIBBLE_MAX_DATA_FIELDS);