var _x = 10;
var _y = 10;

var _element = scribble("[jitter]jittery text jittery text jittery text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_jitter(0.1, SCRIBBLE_DEFAULT_JITTER_SPEED);
var _element = scribble("[jitter]smaller scale");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_jitter(0.5, SCRIBBLE_DEFAULT_JITTER_SPEED);
var _element = scribble("[jitter]larger scale");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_jitter(SCRIBBLE_DEFAULT_JITTER_SCALE, 0.55);
var _element = scribble("[jitter]higher speed");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_jitter(0.5, 0.1);
var _element = scribble("[jitter]larger scale, lower speed");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();