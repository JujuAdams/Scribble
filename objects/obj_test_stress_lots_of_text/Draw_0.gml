var _t = get_timer();
repeat(1000) scribble(test_text).wrap(room_width).draw(room_width, 90);
_t = get_timer() - _t;

smoothed_time = lerp(smoothed_time, _t, 0.01);

draw_set_font(scribble_fallback_font);
draw_text(10, 10, "time taken = " + string(smoothed_time));
draw_text(10, 30, "fps_real = " + string(fps_real));
draw_text(10, 50, "SCRIBBLE_INCREMENTAL_FREEZE = " + string(SCRIBBLE_INCREMENTAL_FREEZE));