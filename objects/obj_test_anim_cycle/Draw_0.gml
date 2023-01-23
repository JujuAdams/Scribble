var _x = 10;
var _y = 10;

var _element = scribble("[cycle, 200, 140, 190, 150]cycling text cycling text cycling text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(0.5, 180, 255);
var _element = scribble("[cycle, 200, 140, 190, 150]higher speed");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(0.3, 80, 155);
var _element = scribble("[cycle, 200, 140, 190, 150]lower saturation");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(0.3, 180, 155);
var _element = scribble("[cycle, 200, 140, 190, 150]lower value (brightness)");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(0.1, 255, 255);
var _element = scribble("[cycle, 200, 140, 190, 150]lower speed, higher saturation, same brightness");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();