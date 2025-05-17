var _element = scribble(test_plain);
_element.draw(x, y);

var _bbox = _element.get_bbox(x, y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_line(0, y + 120, room_width, y + 120);
draw_set_font(font);
draw_text(x, y + 120, test_plain);