var _element = scribble("[pin_right]hello world")
.pin_guide_width(width);
_element.draw(10, 10);

draw_line(10 + width, 0, 10 + width, room_height);

var _bbox = _element.get_bbox(10, 10);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);