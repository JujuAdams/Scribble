var _x = 10;
var _y = 10;

var _element = scribble("default\ndefault\ndefault");
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y += _element.get_height() + 30;

var _element = scribble("[super]adjusted\nadjusted\nadjusted");
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y += _element.get_height() + 30;