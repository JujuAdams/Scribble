var _x = 10;
var _y = 10;

var _element = scribble("[shake]shaky text shaky text shaky text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[shake]smaller amplitude", 1);
_element.animation_shake(1, 0.4).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[shake]slower", 2);
_element.animation_shake(3, 0.1).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[shake]larger amplitude, faster", 4);
_element.animation_shake(5, 0.6).draw(_x, _y);
_y += _element.get_height() + 10;