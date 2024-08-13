var _element = scribble("[scale,2][c_black]" + test_string)
.align(fa_center, fa_middle)
.sdf_outline(c_yellow, 4*mouse_x/room_width);

_element.draw(room_width - 800, room_height div 2);