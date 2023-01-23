var _x = 10;
var _y = 10;

var _element = scribble("[jitter]jittery text jittery text jittery text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_jitter(0.4, 1.2, 0.4);
var _element = scribble("[jitter]smaller min scale");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_jitter(0.8, 1.6, 0.4);
var _element = scribble("[jitter]larger max scale");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_jitter(0.8, 1.2, 0.55);
var _element = scribble("[jitter]higher speed");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_jitter(0.9, 1.1, 0.1);
var _element = scribble("[jitter]larger min scale, smaller max scale, lower speed");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();