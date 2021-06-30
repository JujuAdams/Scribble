var _x = 10;
var _y = 10;

var _element = scribble("Standard text without fogging");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Fogging test using a yellow colour at 50% blending");
_element.fog(c_yellow, 0.5);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Fogging test using [c_lime]green text and a pink fog[/c] and 50% blending");
_element.fog(c_fuchsia, 0.5);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Fogging test with 0% blend");
_element.fog(c_fuchsia, 0.0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Fogging test with pulsing blend");
_element.fog(c_aqua, 0.5 + 0.5*dsin(current_time/10));
_element.draw(_x, _y);
_y += _element.get_height() + 10;