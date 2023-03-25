var _x = 10;
var _y = 10;

var _element = scribble("Default\nbehaviour\ntest");
_element.draw(_x, _y);

_y += _element.get_height() + 30;

var _element = scribble("Fixed size\nbehaviour\ntest");
_element.line_spacing(15);
_element.draw(_x, _y);

_y += _element.get_height() + 30;

var _element = scribble("Double spacing\nbehaviour\ntest");
_element.line_spacing("200%");
_element.draw(_x, _y);

_y += _element.get_height() + 30;