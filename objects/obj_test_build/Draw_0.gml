//Don't remove this scribble() call!
//This call ensures that Scribble's garbage collector runs outside of the timers
scribble("[fnt_test_0]Frozen vertex buffer test").draw(10, 10);

draw_set_font(scribble_fallback_font);
draw_text(10, 30, frozen_smoothed);
draw_text(10 + room_width*0.5, 30, unfrozen_smoothed);

var _t = get_timer();
repeat(20) frozen_element.draw(10, 50);
frozen_smoothed = lerp(frozen_smoothed, get_timer() - _t, 0.03);

var _t = get_timer();
repeat(20) unfrozen_element.draw(10 + room_width*0.5, 50);
unfrozen_smoothed = lerp(unfrozen_smoothed, get_timer() - _t, 0.03);