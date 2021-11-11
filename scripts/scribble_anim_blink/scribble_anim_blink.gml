/// @param onDuration
/// @param offDuration
/// @param timeOffset

function scribble_anim_blink(_on_duration, _off_duration, _time_offset)
{
    if ((_on_duration != global.__scribble_anim_blink_on_duration) || (_off_duration != global.__scribble_anim_blink_off_duration) || (_time_offset != global.__scribble_anim_blink_time_offset))
    {
        global.__scribble_anim_blink_on_duration  = _on_duration;
        global.__scribble_anim_blink_off_duration = _off_duration;
        global.__scribble_anim_blink_time_offset  = _time_offset;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}