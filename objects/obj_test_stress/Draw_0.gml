if (toggle)
{
    test_text = "[fa_middle][fa_center]";
    repeat(irandom_range(1000, 1000)) test_text += chr(irandom_range(32, 127));
    
    var _t = get_timer();
    scribble(test_text).wrap(500).draw(room_width div 2, room_height div 2);
    _t = get_timer() - _t;
    
    smoothed_time = lerp(smoothed_time, _t, 0.01);
}
else
{
    __scribble_garbage_collect();
}

draw_text(10, 10, "models cached = " + string(ds_list_size(global.__scribble_model_cache_list)) + "/" + string(ds_map_size(global.__scribble_model_cache)));
draw_text(10, 30, "elements cached = " + string(ds_list_size(global.__scribble_element_cache_list)) + "/" + string(ds_map_size(global.__scribble_element_cache)));
draw_text(10, 50, "string buffer size = " + string(buffer_get_size(global.__scribble_buffer)));

draw_text(10, 70, "time taken = " + string(smoothed_time));
draw_text(10, 90, "fps_real = " + string(fps_real));