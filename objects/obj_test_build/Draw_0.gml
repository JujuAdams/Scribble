draw_text(10, 10, "SCRIBBLE_INCREMENTAL_FREEZE = " + string(SCRIBBLE_INCREMENTAL_FREEZE));

draw_set_font(scribble_fallback_font);
draw_text(10, 30, frozen_smoothed);
draw_text(10 + room_width*0.5, 30, unfrozen_smoothed);

var _t = get_timer();
repeat(20) frozen_element.draw(10, 50);
frozen_smoothed = lerp(frozen_smoothed, get_timer() - _t, 0.03);

var _t = get_timer();
repeat(20) unfrozen_element.draw(10 + room_width*0.5, 50);
unfrozen_smoothed = lerp(unfrozen_smoothed, get_timer() - _t, 0.03);