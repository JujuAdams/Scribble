var _element = scribble("Test text Test text Test text").fit_to_box(mouse_x - x, mouse_y - y).padding(10, 10, 10, 10);

var _bbox = _element.get_bbox(x, y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

_element.draw(x, y);

draw_line(x, y, room_width, y);
draw_line(x, y, x, room_height);
draw_line(mouse_x, 0, mouse_x, room_height);
draw_line(0, mouse_y, room_width, mouse_y);