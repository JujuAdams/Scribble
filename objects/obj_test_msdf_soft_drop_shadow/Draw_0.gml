draw_clear(c_white);

var _element = scribble("[scale,2][c_white]SPHINX OF BLACK QUARTZ, JUDGE MY VOW")
.align(fa_center, fa_middle)
.msdf_shadow(c_black, 0.2, lerp(-4, 4, mouse_x/room_width), lerp(-4, 4, mouse_y/room_height), 0);

scribble_msdf_thickness_offset(0.05);

_element.draw(room_width - 800, room_height div 2);