var _element = scribble(test_animation).align(fa_center, fa_left).layout_fit(width, height);
_element.draw(x + width/2, y);

var _bbox = _element.get_bbox(x + width/2, y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_set_color(c_yellow);
draw_line(x, y, x, room_height);
draw_line(x, y, room_width, y);
draw_line(x + width, 0, x + width, room_height);
draw_line(0, y + height, room_width, y + height);
draw_set_color(c_white);

draw_text(10, room_height - 20, string(width) + " x " + string(height));
