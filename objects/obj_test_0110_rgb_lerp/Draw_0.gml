var _t = mouse_x / room_width;

var _x = 10;
var _y = 10;

var _element = scribble_unique(0, "[c_coquelicot]Test[/c] white").rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(1, "Test grey").rgb_multiply(c_grey).rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(2, "Test red").rgb_multiply("c_coquelicot").rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(3, "Test red").colour("c_coquelicot").rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(4, "[#ff3800]Test[/c] white").rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(5, "[d#" + string(0x0038FF) + "]Test[/c] white").rgb_lerp(c_red, _t);
_element.draw(_x, _y);
_y += _element.get_height() + 10;