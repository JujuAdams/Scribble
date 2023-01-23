var _x = 10;
var _y = 10;

var _element = scribble("[shake]shaky text shaky text shaky text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_shake(1, 0.4);
var _element = scribble("[shake]smaller amplitude");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_shake(3, 0.1);
var _element = scribble("[shake]slower");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_shake(5, 0.6);
var _element = scribble("[shake]larger amplitude, faster");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();