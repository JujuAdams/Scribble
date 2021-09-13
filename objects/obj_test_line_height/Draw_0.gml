var _x = 10;
var _y = 10;

var _element = scribble("minimum = -1\nmaximum = -1");
_element.line_height(-1, -1);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y += _element.get_height() + 20;

var _element = scribble("minimum = 0\nmaximum = 0");
_element.line_height(0, 0);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y += _element.get_height() + 20;

var _element = scribble("minimum = 0\nmaximum = 100");
_element.line_height(0, 100);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y += _element.get_height() + 20;

var _element = scribble("minimum = 100\nmaximum = 100");
_element.line_height(100, 100);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y += _element.get_height() + 20;