var _x = 10;
var _y = 10;

var _element = scribble("This is some static text that is not animated.");
_element.draw(_x, _y);
draw_text(_x + _element.get_width() + 20, _y, ".is_animated() = " + string(_element.is_animated()));
_y += _element.get_height() + 10;

var _element = scribble("This is some text with an animated in-line sprite [spr_coin]");
_element.draw(_x, _y);
draw_text(_x + _element.get_width() + 20, _y, ".is_animated() = " + string(_element.is_animated()));
_y += _element.get_height() + 10;

var _element = scribble("This is some text with two non-animated in-line sprite [spr_coin,0,0] [spr_static_coin]");
_element.draw(_x, _y);
draw_text(_x + _element.get_width() + 20, _y, ".is_animated() = " + string(_element.is_animated()));
_y += _element.get_height() + 10;

var _element = scribble("[rainbow]This is some rainbow text (which is an animation)");
_element.draw(_x, _y);
draw_text(_x + _element.get_width() + 20, _y, ".is_animated() = " + string(_element.is_animated()));
_y += _element.get_height() + 10;

var _element = scribble("[cycle, 200, 140, 190, 150]This is some colour-cycling text (which is an animation)");
_element.draw(_x, _y);
draw_text(_x + _element.get_width() + 20, _y, ".is_animated() = " + string(_element.is_animated()));
_y += _element.get_height() + 10;

scribble_anim_reset();
