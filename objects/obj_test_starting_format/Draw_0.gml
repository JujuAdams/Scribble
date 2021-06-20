var _x = 10;
var _y = 10;

var _element = scribble("Here's a string, the style of which will be changed by .starting_format()", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Text in red", 1);
_element.starting_format(undefined, c_red).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Text using a smaller font", 2);
_element.starting_format("fnt_test_0", undefined).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Text using an MSDF font in lime green", 3);
_element.starting_format("spr_msdf_openhuninn", c_lime).draw(_x, _y);
_y += _element.get_height() + 10;