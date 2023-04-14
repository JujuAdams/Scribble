var _t = mouse_x / room_width;

var _x = 10;
var _y = 10;

var _element = scribble("[c_coquelicot]Test[/c] white", 0).rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Test grey", 1).rgb_multiply(c_grey).rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Test red", 2).rgb_multiply("c_coquelicot").rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Test red", 3).colour("c_coquelicot").rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[#ff3800]Test[/c] white", 4).rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[d#" + string(0x0038FF) + "]Test[/c] white", 5).rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;