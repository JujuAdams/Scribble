draw_clear(c_white);

var _element = scribble("[scale,2][c_white]" + test_string)
.align(fa_center, fa_middle)
.msdf_shadow(c_black, 1, 2, 2, mouse_y / room_height);

_element.draw(room_width - 800, room_height div 2);