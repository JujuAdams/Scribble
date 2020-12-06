/// Resets Scribble's draw state
/// 
/// You are welcome to edit this script!

function scribble_reset()
{
    global.scribble_state_starting_font   = global.__scribble_default_font; //Name of the starting font for every text element. Name must be a string. This is the font that is set when [/] or [/font] is used in a string
    global.scribble_state_starting_color  = c_white;                        //Starting colour for every text element
    global.scribble_state_starting_halign = fa_left;                        //Starting horizontal alignment for every text element
    global.scribble_state_xscale          = 1;                              //x-scale of the textbox
    global.scribble_state_yscale          = 1;                              //y-scale of the textbox
    global.scribble_state_angle           = 0;                              //Rotation of the textbox
    global.scribble_state_colour          = c_white;                        //Blend colour to use for every text element
    global.scribble_state_alpha           = 1.0;                            //Blend alpha to use for every text element
    global.scribble_state_line_min_height = -1;                             //Minimum height of each line of text. Set to a negative value to use the height of a space character of the default font.
    global.scribble_state_line_max_height = -1;                             //Maximum line height for each line of text. Use a negative number (the default) for no limit
    global.scribble_state_max_width       = -1;                             //Maximum horizontal size of the textbox. Set to a negative value for no limit.
    global.scribble_state_max_height      = -1;                             //Maximum vertical size of the textbox. Set to a negative value for no limit.
    global.scribble_state_character_wrap  = false;                          //Set to <true> to allow characters to be put onto new lines by themselves
    global.scribble_state_box_halign      = fa_left;                        //fa_left places the left-hand side of the box at the draw coordinate when using scribble_draw().
    global.scribble_state_box_valign      = fa_top;                         //fa_top places the top of the box at the draw coordinate when using scribble_draw().
    global.scribble_state_box_align_page  = false;                          //Whether to use text element sizes (false) or page sizes (true)
    global.scribble_state_fog_colour      = c_fuchsia;                      //Fog colour
    global.scribble_state_fog_alpha       = 0.0;                            //Fog blend factor
    global.scribble_state_ignore_commands = false;                          //Whether to ignore command tags and to write strings out literally
    
    scribble_set_bezier();
    
    scribble_set_animation(SCRIBBLE_ANIM.WAVE_SIZE       ,  4   );
    scribble_set_animation(SCRIBBLE_ANIM.WAVE_FREQ       , 50   );
    scribble_set_animation(SCRIBBLE_ANIM.WAVE_SPEED      ,  0.2 );
    scribble_set_animation(SCRIBBLE_ANIM.SHAKE_SIZE      ,  2   );
    scribble_set_animation(SCRIBBLE_ANIM.SHAKE_SPEED     ,  0.4 );
    scribble_set_animation(SCRIBBLE_ANIM.RAINBOW_WEIGHT  ,  0.5 );
    scribble_set_animation(SCRIBBLE_ANIM.RAINBOW_SPEED   ,  0.01);
    scribble_set_animation(SCRIBBLE_ANIM.WOBBLE_ANGLE    , 40   );
    scribble_set_animation(SCRIBBLE_ANIM.WOBBLE_FREQ     ,  0.15);
    scribble_set_animation(SCRIBBLE_ANIM.PULSE_SCALE     ,  0.4 );
    scribble_set_animation(SCRIBBLE_ANIM.PULSE_SPEED     ,  0.1 );
    scribble_set_animation(SCRIBBLE_ANIM.WHEEL_SIZE      ,  1   );
    scribble_set_animation(SCRIBBLE_ANIM.WHEEL_FREQ      ,  0.5 );
    scribble_set_animation(SCRIBBLE_ANIM.WHEEL_SPEED     ,  0.2 );
    scribble_set_animation(SCRIBBLE_ANIM.CYCLE_SPEED     ,  0.3 );
    scribble_set_animation(SCRIBBLE_ANIM.CYCLE_SATURATION,  255 );
    scribble_set_animation(SCRIBBLE_ANIM.CYCLE_VALUE     ,  255 );
    scribble_set_animation(SCRIBBLE_ANIM.JITTER_MINIMUM  ,  0.8 );
    scribble_set_animation(SCRIBBLE_ANIM.JITTER_MAXIMUM  ,  1.2 );
    scribble_set_animation(SCRIBBLE_ANIM.JITTER_SPEED    ,  0.4 );
}
