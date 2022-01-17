var _x = 10;
var _y = 10;

var _element = scribble("[rainbow]rainbow text rainbow text rainbow text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_rainbow(1, 0.01);
var _element = scribble("[rainbow]higher weight", 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_rainbow(0.5, 0.003);
var _element = scribble("[rainbow]lower speed", 2);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_rainbow(0.3, 0.05);
var _element = scribble("[rainbow]lower weight, higher speed", 3);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();