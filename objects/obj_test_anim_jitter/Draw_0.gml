var _x = 10;
var _y = 10;

var _element = scribble("[jitter]jittery text jittery text jittery text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[jitter]smaller min scale", 1);
_element.animation_jitter(0.4, 1.2, 0.4).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[jitter]larger max scale", 2);
_element.animation_jitter(0.8, 1.6, 0.4).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[jitter]higher speed", 3);
_element.animation_jitter(0.8, 1.2, 0.55).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[jitter]larger min scale, smaller max scale, lower speed", 4);
_element.animation_jitter(0.9, 1.1, 0.1).draw(_x, _y);
_y += _element.get_height() + 10;