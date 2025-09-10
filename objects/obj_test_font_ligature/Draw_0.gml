// Feather disable all

draw_text(10, 60, $"SCRIBBLE_ALLOW_LIGATURES = {SCRIBBLE_ALLOW_LIGATURES}");

var _element = scribble("[fnt_test_0]Here are some ligatures: fi ff ffi\nBut this isn't: f[zwsp]i f[zwsp]f f[zwsp]f[zwsp]i")
var _reveal = (mouse_x / room_width) * (1 + _element.get_reveal_count());
_element.draw(10, 10, _reveal);