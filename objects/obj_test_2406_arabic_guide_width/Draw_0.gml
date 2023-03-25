var _element = scribble(test_mode? test_l2r : test_r2l).layout_guide(width);
_element.draw(x, y);

var _bbox = _element.get_bbox(x, y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_set_color(c_yellow);
draw_line(x, y, x, room_height);
draw_line(x, y, room_width, y);
draw_line(x + width, 0, x + width, room_height);
draw_set_color(c_white);