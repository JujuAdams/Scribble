var _x = 10;
var _y = 10;

var _element = scribble("[cycle, 200, 140, 190, 150]cycling text cycling text cycling text", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[cycle, 200, 140, 190, 150]higher speed", 1);
_element.animation_cycle(0.5, 180, 255).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[cycle, 200, 140, 190, 150]lower saturation", 2);
_element.animation_cycle(0.3, 80, 255).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[cycle, 200, 140, 190, 150]lower value (brightness)", 3);
_element.animation_cycle(0.3, 180, 155).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[cycle, 200, 140, 190, 150]lower speed, higher saturation, same brightness", 4);
_element.animation_cycle(0.1, 255, 255).draw(_x, _y);
_y += _element.get_height() + 10;