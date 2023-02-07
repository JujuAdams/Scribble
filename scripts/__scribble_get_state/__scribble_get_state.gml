function __scribble_get_state()
{
    static _struct = {
        __frames: 0,
        
        __default_font: "scribble_fallback_font",
        
        __blink_on_duration:  SCRIBBLE_DEFAULT_BLINK_ON_DURATION,
        __blink_off_duration: SCRIBBLE_DEFAULT_BLINK_OFF_DURATION,
        __blink_time_offset:  SCRIBBLE_DEFAULT_BLINK_TIME_OFFSET,
        
        __shader_anim_desync:            false,
        __shader_anim_desync_to_default: false,
        __shader_anim_default:           false,
        
        __sdf_thickness_offset: 0,

        __markdown_styles_struct: {},
        
        __font_add_cache_array: [],
        
        __font_data_map: ds_map_create(), //TODO - Could we do this with a struct?
    };
    
    return _struct;
}