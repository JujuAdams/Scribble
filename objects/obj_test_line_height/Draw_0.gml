var _x = 10;
var _y = 10;

var _element = scribble("line height\n= -1");
_element.line_height(-1);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y += _element.get_height() + 30;

var _element = scribble("line height\n= 20");
_element.line_height(20);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y += _element.get_height() + 30;

var _element = scribble("line height\n= 100");
_element.line_height(100);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y += _element.get_height() + 30;