var _x = 10;
var _y = 10;

var _element = scribble("[wobble]wobbly text wobbly text wobbly text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wobble(20, 0.15);
var _element = scribble("[wobble]smaller angle", 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wobble(40, 0.25);
var _element = scribble("[wobble]higher frequency", 2);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wobble(75, 0.05);
var _element = scribble("[wobble]larger angle, lower frequency", 3);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();