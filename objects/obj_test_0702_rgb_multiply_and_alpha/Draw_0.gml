var _x = 10;
var _y = 10;

var _element = scribble("Blend red");
_element.rgb_multiply(c_red);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Blend low alpha");
_element.alpha(0.5);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Blend low alpha and lime green");
_element.rgb_multiply(c_lime);
_element.alpha(0.5);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[rainbow]Blend low alpha and blue against rainbow effect");
_element.rgb_multiply(c_blue);
_element.alpha(0.5);
_element.draw(_x, _y);
_y += _element.get_height() + 10;