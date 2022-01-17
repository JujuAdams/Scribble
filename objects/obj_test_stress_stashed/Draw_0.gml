draw_set_font(scribble_fallback_font);

var _t = get_timer();
repeat(100) element.draw(room_width div 2, room_height div 2);
_t = get_timer() - _t;

smoothed_time_scribble = lerp(smoothed_time_scribble, _t, 0.01);

draw_set_halign(fa_center);
draw_set_halign(fa_middle);
var _t = get_timer();
repeat(100) draw_text(room_width div 2, room_height div 2, test_text);
_t = get_timer() - _t;
draw_set_halign(fa_left);
draw_set_halign(fa_top);

smoothed_time_gm = lerp(smoothed_time_gm, _t, 0.01);

draw_text(10, 10, "Scribble time taken = " + string(smoothed_time_scribble));
draw_text(10, 30, "GM time taken = " + string(smoothed_time_gm));