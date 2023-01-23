var _x = 10;
var _y = 10;

var _element = scribble("[wave]wavy text wavy text wavy text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wave(7, 50, 0.2);
var _element = scribble("[wave]larger amplitude");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wave(4, 25, 0.2);
var _element = scribble("[wave]looooooooower frequencyyyyyyyyy");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wave(6, 50, 0.4);
var _element = scribble("[wave]higher speed");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_wave(2, 75, 0.4);
var _element = scribble("[wave]smaller amplitude, higher frequency, faster");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();