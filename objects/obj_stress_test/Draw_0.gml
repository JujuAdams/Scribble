var _string = "";
repeat(irandom_range(1000, 1000)) _string += chr(irandom_range(32, 127));
scribble_set_wrap(500, -1);
scribble_set_box_align(fa_center, fa_middle);

var _t = get_timer();
scribble_draw(room_width div 2, room_height div 2, _string);
_t = get_timer() - _t;

scribble_reset();

draw_text(10, 10, "cache size = " + string(ds_list_size(global.__scribble_global_cache_list)));

smoothed_time = lerp(smoothed_time, _t, 0.01);
draw_text(10, 30, "time taken = " + string(smoothed_time));