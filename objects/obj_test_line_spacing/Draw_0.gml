var _x = 10;
var _y = 10;

var _element = scribble("Default\nbehaviour\ntest");
var _bbox = _element.get_bbox(_x, _y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);
_element.draw(_x, _y);

_y += _element.get_height() + 30;

var _element = scribble("Fixed size\nbehaviour\ntest");
_element.line_spacing(15);
var _bbox = _element.get_bbox(_x, _y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);
_element.draw(_x, _y);

_y += _element.get_height() + 30;

var _element = scribble("Double spacing\nbehaviour\ntest");
_element.line_spacing("200%");
var _bbox = _element.get_bbox(_x, _y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);
_element.draw(_x, _y);

_y += _element.get_height() + 30;

var _element = scribble("Two lines in\nthis element");
_element.align(fa_center, fa_middle);
_element.line_spacing("50%");
var _bbox = _element.get_bbox(room_width/2, room_height/2);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);
_element.draw(room_width/2, room_height/2);
draw_line(room_width/2 - 200, room_height/2, room_width/2 + 200, room_height/2);