function __scribble_get_state()
{
    static _struct = {
        __frames: 0,
        
        __default_font: "scribble_fallback_font",
        
        __blink_on_duration:  SCRIBBLE_DEFAULT_BLINK_ON_DURATION,
        __blink_off_duration: SCRIBBLE_DEFAULT_BLINK_OFF_DURATION,
        __blink_time_offset:  SCRIBBLE_DEFAULT_BLINK_TIME_OFFSET,
        
        __shader_anim_desync:            true,
        __shader_anim_desync_to_default: true,
        __shader_anim_default:           false,
        
        __sdf_thickness_offset: 0,

        __effects_dict:           {},
        __effects_slash_dict:     {},
        __typewriter_events_dict: {},
        __markdown_styles_struct: {},
        
        __font_add_cache_array: [],
        
        __render_flag_value:  0x02,
        __premultiply_alpha:  false,
        __blend_sprites:      true,
        
        __font_original_name_dict: {},
        __font_data_map: ds_map_create(), //TODO - Could we do this with a struct?
        
        __custom_colour_struct: {
            //Duplicate GM's native colour constants
            c_aqua:    c_aqua,
            c_black:   c_black,
            c_blue:    c_blue,
            c_dkgray:  c_dkgray,
            c_dkgrey:  c_dkgrey,
            c_fuchsia: c_fuchsia,
            c_gray:    c_gray,
            c_green:   c_green,
            c_gray:    c_gray,
            c_grey:    c_grey,
            c_lime:    c_lime,
            c_ltgray:  c_ltgray,
            c_ltgrey:  c_ltgrey,
            c_maroon:  c_maroon,
            c_navy:    c_navy,
            c_olive:   c_olive,
            c_orange:  c_orange,
            c_purple:  c_purple,
            c_red:     c_red,
            c_silver:  c_silver,
            c_teal:    c_teal,
            c_white:   c_white,
            c_yellow:  c_yellow,
        },
        
        __cycle_surface:    -1,
        __cycle_dict:       {},
        __cycle_open_array: array_create(SCRIBBLE_CYCLE_COUNT),
    };
    
    return _struct;
}