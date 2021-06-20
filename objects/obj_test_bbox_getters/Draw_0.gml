var _x = 10;
var _y = 10;

var _element = scribble("Basic text boundary check\nwith newline!");
draw_rectangle(_x, _y, _x + _element.get_width(), _y + _element.get_height(), true);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble(".get_width() and .get_height() intentionally ignore .transform()");
_element.transform(1.1, 1.1, 0);
draw_rectangle(_x, _y, _x + _element.get_width(), _y + _element.get_height(), true);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Test using .get_bbox()\n (and a newline)", 2);
_element.transform(1.2, 1.2, 0);
var _bbox = _element.get_bbox(_x, _y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);
_element.draw(_x, _y);
_y += _element.get_height() + 10;