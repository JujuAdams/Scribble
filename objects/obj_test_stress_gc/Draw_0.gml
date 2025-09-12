if (toggle)
{
    test_text = "[fa_middle][fa_center]";
    repeat(1000) test_text += chr(choose(32, irandom_range(32, 90), irandom_range(94, 126), irandom_range(94, 126)));
    counter++;
}

var _t = get_timer();
if (not keyboard_check(vk_shift))
{
    scribble(test_text).max_size(500).layout(SCRIBBLE_LAYOUT_WRAP).draw(room_width div 2, room_height div 2);
}
_t = get_timer() - _t;

smoothed_time = lerp(smoothed_time, _t, 0.01);

var _system = __scribble_system();

draw_set_font(scribble_fallback_font);
draw_text(10,  30, "cache array = " + string(array_length(_system.__elementWeakArray)));
draw_text(10,  50, "cache map = " + string(ds_map_size(_system.__elementCacheMap)));
draw_text(10,  90, "counter = " + string(counter));
               
draw_text(10, 130, "time taken = " + string(smoothed_time));
draw_text(10, 150, "fps_real = " + string(fps_real));