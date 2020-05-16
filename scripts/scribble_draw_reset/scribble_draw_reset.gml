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

scribble_draw_set_animation(SCRIBBLE_ANIM.WAVE_SIZE     ,  4   );
scribble_draw_set_animation(SCRIBBLE_ANIM.WAVE_FREQ     , 50   );
scribble_draw_set_animation(SCRIBBLE_ANIM.WAVE_SPEED    ,  0.2 );
scribble_draw_set_animation(SCRIBBLE_ANIM.SHAKE_SIZE    ,  4   );
scribble_draw_set_animation(SCRIBBLE_ANIM.SHAKE_SPEED   ,  0.4 );
scribble_draw_set_animation(SCRIBBLE_ANIM.RAINBOW_WEIGHT,  0.5 );
scribble_draw_set_animation(SCRIBBLE_ANIM.RAINBOW_SPEED ,  0.01);
scribble_draw_set_animation(SCRIBBLE_ANIM.WOBBLE_ANGLE  , 40   );
scribble_draw_set_animation(SCRIBBLE_ANIM.WOBBLE_FREQ   ,  0.15);
scribble_draw_set_animation(SCRIBBLE_ANIM.PULSE_SCALE   ,  0.4 );
scribble_draw_set_animation(SCRIBBLE_ANIM.PULSE_SPEED   ,  0.1 );
scribble_draw_set_animation(SCRIBBLE_ANIM.WHEEL_SIZE    ,  1   );
scribble_draw_set_animation(SCRIBBLE_ANIM.WHEEL_FREQ    ,  0.5 );
scribble_draw_set_animation(SCRIBBLE_ANIM.WHEEL_SPEED   ,  0.2 );