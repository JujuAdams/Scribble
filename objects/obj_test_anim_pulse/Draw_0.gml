var _x = 10;
var _y = 10;

var _element = scribble("[pulse]pulsing text pulsing text pulsing text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_pulse(0.2, 0.1);
var _element = scribble("[pulse]smaller scale", 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_pulse(0.4, 0.02);
var _element = scribble("[pulse]slower speed", 2);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_pulse(0.8, 0.16);
var _element = scribble("[pulse]higher scale, higher speed", 3);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();