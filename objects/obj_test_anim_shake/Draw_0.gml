var _x = 10;
var _y = 10;

var _element = scribble("[shake]shaky text shaky text shaky text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_shake(1, 0.4);
var _element = scribble("[shake]smaller amplitude", 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_shake(3, 0.1);
var _element = scribble("[shake]slower", 2);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_shake(5, 0.6);
var _element = scribble("[shake]larger amplitude, faster", 4);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();