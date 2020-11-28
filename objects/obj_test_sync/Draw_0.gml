var _a = scribble("[wave]Here's is a string that'll wave slowly").animation_tick_speed(0.2);
var _b = scribble("[wave]Here's a string that'll synchronise to the above after you press space");

if (keyboard_check_pressed(vk_space)) _b.sync(_a);

_a.draw(10, 10);
_b.draw(10, 50);