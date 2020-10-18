var _string = "[fa_middle][fa_center]";
repeat(irandom_range(1000, 1000)) _string += chr(irandom_range(32, 127));

var _t = get_timer();
scribble(_string).wrap(500).draw(room_width div 2, room_height div 2);
_t = get_timer() - _t;

draw_text(10, 10, "models cached = " + string(ds_list_size(global.__scribble_model_cache_list)));
draw_text(10, 30, "elements cached = " + string(ds_list_size(global.__scribble_element_cache_list)));

smoothed_time = lerp(smoothed_time, _t, 0.01);
draw_text(10, 50, "time taken = " + string(smoothed_time));