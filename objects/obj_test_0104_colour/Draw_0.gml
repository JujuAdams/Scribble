var _x = 10;
var _y = 10;

var _element = scribble("[c_coquelicot]Test[/c] white");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Test grey").rgb_multiply(c_grey);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Test coquelicot via blend").rgb_multiply("c_coquelicot");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Test coquelicot via starting format").colour("c_coquelicot");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[#ff3800]Test[/c] white");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[d#" + string(0x0038FF) + "]Test[/c] white");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[c_banana]Press space to cycle this colour[/c] (colour=" + string(scribble_color_get("c_banana")) + ")");
_element.draw(_x, _y);
_y += _element.get_height() + 10;