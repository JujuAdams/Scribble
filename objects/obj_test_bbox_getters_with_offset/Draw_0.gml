var _x = 10;
var _y = 10;

var _xStart = _x;

var _element = scribble("Basic text boundary check with [offset,0,10]offset!", 1).visual_bboxes(false);
draw_rectangle(_x, _y, _x + _element.get_width(), _y + _element.get_height(), true);
_element.draw(_x, _y);
_x += _element.get_width() + 5;

var _element = scribble("Basic text boundary check with [offset,0,10]offset!", 2).visual_bboxes(true);
draw_rectangle(_x, _y, _x + _element.get_width(), _y + _element.get_height(), true);
_element.draw(_x, _y);

_x = _xStart;
_y += _element.get_height() + 5;

var _element = scribble("Basic text boundary check with [offset,0,10]offset!", 2).visual_bboxes(true);
draw_rectangle(_x, _y, _x + _element.get_width(), _y + _element.get_height(), true);
_element.draw(_x, _y);