var _x = 10;
var _y = 10;

var _element = scribble("Blend red");
_element.blend(c_red, undefined);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Blend low alpha");
_element.blend(undefined, 0.5);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Blend low alpha and lime green");
_element.blend(c_lime, 0.5);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[rainbow]Blend low alpha and blue against rainbow effect");
_element.blend(c_blue, 0.5);
_element.draw(_x, _y);
_y += _element.get_height() + 10;