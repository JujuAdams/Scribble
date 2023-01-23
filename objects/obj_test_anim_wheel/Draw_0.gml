var _x = 10;
var _y = 10;

var _element = scribble("[wheel]wheely text wheely text wheely text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wheel(2, 0.5, 0.2);
var _element = scribble("[wheel]bigger amplitude");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wheel(1, 1.0, 0.2);
var _element = scribble("[wheel]higher frequency");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wheel(1, 0.5, 0.4);
var _element = scribble("[wheel]faster speed");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wheel(0.6, 0.25, 0.1);
var _element = scribble("[wheel]smaller amplitude, lower frequency, lower speed");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();