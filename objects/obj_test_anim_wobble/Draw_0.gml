var _x = 10;
var _y = 10;

var _element = scribble("[wobble]wobbly text wobbly text wobbly text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[wobble]smaller angle", 1);
_element.animation_wobble(20, 0.15).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[wobble]higher frequency", 2);
_element.animation_wobble(40, 0.25).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[wobble]larger angle, lower frequency", 3);
_element.animation_wobble(75, 0.05).draw(_x, _y);
_y += _element.get_height() + 10;