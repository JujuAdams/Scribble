/// @param onDuration   Duration that blinking text should stay on for, in milliseconds
/// @param offDuration  Duration that blinking text should turn off for, in milliseconds
/// @param timeOffset   Blink time offset, in milliseconds

function scribble_anim_blink(_on_duration, _off_duration, _time_offset)
{
    static _scribble_state = __scribble_get_state();
    with(_scribble_state)
    {
        __blink_on_duration  = _on_duration;
        __blink_off_duration = _off_duration;
        __blink_time_offset  = _time_offset;
    }
}