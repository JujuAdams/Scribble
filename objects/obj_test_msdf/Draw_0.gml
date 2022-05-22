var _element = scribble("[fa_center][fa_middle][scale,3]the quick brown fox jumped over the [scale,2]lazy dog") //\n\nSPHINX OF BLACK QUARTZ, JUDGE MY VOW")
.msdf_border(c_navy, 10*mouse_x/room_width)
.msdf_shadow(c_black, 0.3, 4, 4)
.wrap(551)

_element.draw(room_width div 2, room_height div 2);

var _bbox = _element.get_bbox(room_width div 2, room_height div 2);
draw_rectangle(_bbox.x0, _bbox.y0, _bbox.x3, _bbox.y3, true);

draw_line(_bbox.x0, _bbox.y0 - 30, _bbox.x0 + _element.get_width(), _bbox.y0 - 30);