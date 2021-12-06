var _element = scribble("Test text\nTest text\nTest text").padding(10, 10, 10, 10);

var _bbox = _element.get_bbox(10, 10);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

_element.draw(10, 10);

draw_line(10, 10, room_width, 10);
draw_line(10, 10, 10, room_height);