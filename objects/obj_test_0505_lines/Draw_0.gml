var _x = 10;
var _y = 10;

var _element = scribble("line 1\nline 2");
_element.line_height(30);
_element.draw(_x, _y);
draw_line(_x, _y + _element.get_line_y(0), _x + 100, _y + _element.get_line_y(0));
draw_line(_x, _y + _element.get_line_y(1), _x + 100, _y + _element.get_line_y(1));
_y += _element.get_height() + 10;