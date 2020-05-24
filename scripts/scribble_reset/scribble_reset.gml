/// Resets Scribble's draw state

global.scribble_state_occurance       = "default";
global.scribble_state_default_font    = global.__scribble_default_font;
global.scribble_state_default_color   = c_white;
global.scribble_state_default_halign  = fa_left;
global.scribble_state_xscale          = 1;       //x-scale of the textbox
global.scribble_state_yscale          = 1;       //y-scale of the textbox
global.scribble_state_angle           = 0;       //Rotation of the textbox
global.scribble_state_colour          = c_white;
global.scribble_state_alpha           = 1.0;
global.scribble_state_line_min_height = -1;      //Minimum height of each line of text. Set to a negative value to use the height of a space character of the default font.
global.scribble_state_line_max_height = -1;      //Maximum line height for each line of text. Use a negative number (the default) for no limit
global.scribble_state_max_width       = -1;      //Maximum horizontal size of the textbox. Set to a negative value for no limit.
global.scribble_state_max_height      = -1;      //Maximum vertical size of the textbox. Set to a negative value for no limit.
global.scribble_state_character_wrap  = false;
global.scribble_state_box_halign      = fa_left; //fa_left places the left-hand side of the box at the draw coordinate when using scribble_draw().
global.scribble_state_box_valign      = fa_top;  //fa_top places the top of the box at the draw coordinate when using scribble_draw().

scribble_set_animation(SCRIBBLE_ANIM.WAVE_SIZE     ,  4   );
scribble_set_animation(SCRIBBLE_ANIM.WAVE_FREQ     , 50   );
scribble_set_animation(SCRIBBLE_ANIM.WAVE_SPEED    ,  0.2 );
scribble_set_animation(SCRIBBLE_ANIM.SHAKE_SIZE    ,  4   );
scribble_set_animation(SCRIBBLE_ANIM.SHAKE_SPEED   ,  0.4 );
scribble_set_animation(SCRIBBLE_ANIM.RAINBOW_WEIGHT,  0.5 );
scribble_set_animation(SCRIBBLE_ANIM.RAINBOW_SPEED ,  0.01);
scribble_set_animation(SCRIBBLE_ANIM.WOBBLE_ANGLE  , 40   );
scribble_set_animation(SCRIBBLE_ANIM.WOBBLE_FREQ   ,  0.15);
scribble_set_animation(SCRIBBLE_ANIM.PULSE_SCALE   ,  0.4 );
scribble_set_animation(SCRIBBLE_ANIM.PULSE_SPEED   ,  0.1 );
scribble_set_animation(SCRIBBLE_ANIM.WHEEL_SIZE    ,  1   );
scribble_set_animation(SCRIBBLE_ANIM.WHEEL_FREQ    ,  0.5 );
scribble_set_animation(SCRIBBLE_ANIM.WHEEL_SPEED   ,  0.2 );

global.__scribble_cache_string = string(global.scribble_state_default_font   ) + ":" +
                                 string(global.scribble_state_default_color  ) + ":" +
                                 string(global.scribble_state_default_halign ) + ":" +
                                 string(global.scribble_state_line_min_height) + ":" +
                                 string(global.scribble_state_line_max_height) + ":" +
                                 string(global.scribble_state_max_width      ) + ":" +
                                 string(global.scribble_state_max_height     ) + ":" +
                                 string(global.scribble_state_character_wrap );