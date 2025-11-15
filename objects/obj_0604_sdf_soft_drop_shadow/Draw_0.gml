draw_clear(c_gray);

var _element = scribble("[scale,2][c_white]" + test_string)
.align(fa_center, fa_middle)
.sdf_shadow(c_blue, 0.7, 0, 0, 20 * mouse_y / room_height);

_element.draw(room_width div 2, room_height div 2);