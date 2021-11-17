var _element = scribble("[scale,2][c_white]SPHINX OF BLACK QUARTZ, JUDGE MY VOW")
.align(fa_center, fa_middle)
.msdf_shadow(c_black, 0.5, lerp(-4, 4, mouse_x/room_width), lerp(-4, 4, mouse_y/room_height), 0);

_element.draw(room_width div 2, room_height div 2);