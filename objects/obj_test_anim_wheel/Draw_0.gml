var _x = 10;
var _y = 10;

var _element = scribble("[wheel]wheely text wheely text wheely text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wheel(2, 0.5, 0.2);
var _element = scribble("[wheel]bigger amplitude", 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wheel(1, 1.0, 0.2);
var _element = scribble("[wheel]higher frequency", 2);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wheel(1, 0.5, 0.4);
var _element = scribble("[wheel]faster speed", 3);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wheel(0.6, 0.25, 0.1);
var _element = scribble("[wheel]smaller amplitude, lower frequency, lower speed", 4);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();