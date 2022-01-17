var _x = 10;
var _y = 10;

var _element = scribble("[wave]wavy text wavy text wavy text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wave(7, 50, 0.2);
var _element = scribble("[wave]larger amplitude", 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wave(4, 25, 0.2);
var _element = scribble("[wave]looooooooower frequencyyyyyyyyy", 2);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wave(6, 50, 0.4);
var _element = scribble("[wave]higher speed", 3);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wave(2, 75, 0.4);
var _element = scribble("[wave]smaller amplitude, higher frequency, faster", 3);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();