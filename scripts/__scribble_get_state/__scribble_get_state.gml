function __scribble_get_state()
{
    static _struct = {
        __frames: 0,
        
        __default_font: "scribble_fallback_font",
        
        __blink_on_duration:  SCRIBBLE_DEFAULT_BLINK_ON_DURATION,
        __blink_off_duration: SCRIBBLE_DEFAULT_BLINK_OFF_DURATION,
        __blink_time_offset:  SCRIBBLE_DEFAULT_BLINK_TIME_OFFSET,
        
        __standard_anim_desync:            false,
        __standard_anim_desync_to_default: false,
        __standard_anim_default:           false,
        
        __msdf_anim_desync:            false,
        __msdf_anim_desync_to_default: false,
        __msdf_anim_default:           false,
        
        __msdf_thickness_offset: 0,
        
        __markdown_styles_struct: {},
    };
    
    return _struct;
}