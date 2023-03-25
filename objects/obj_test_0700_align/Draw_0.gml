var _x = room_width div 2;
var _y = 10;

var _element = scribble("Left aligned");
_element.align(fa_left, undefined);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Centre aligned");
_element.align(fa_center, undefined);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Right aligned");
_element.align(fa_right, undefined);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Pin left\nText to stretch out the bbox");
_element.align("pin_left", undefined);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Centre pin\nText to stretch out the bbox");
_element.align("pin_center", undefined);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Right pin\nText to stretch out the bbox");
_element.align("pin_right", undefined);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

draw_line(_x, 10, _x, _y);

_x  = 10
_y += 50;

var _element = scribble("Top aligned");
_element.align(fa_left, fa_top);
_element.draw(_x, _y);
_x += _element.get_width() + 10;

var _element = scribble("Middle aligned");
_element.align(fa_left, fa_middle);
_element.draw(_x, _y);
_x += _element.get_width() + 10;

var _element = scribble("Bottom aligned");
_element.align(fa_left, fa_bottom);
_element.draw(_x, _y);
_x += _element.get_width() + 10;

draw_line(10, _y, _x, _y);