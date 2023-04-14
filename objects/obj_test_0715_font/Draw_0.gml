var _x = 10;
var _y = 10;

var _element = scribble("Here's a string, the style of which will be changed by .font()", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Text using a smaller font", 1);
_element.font("fnt_test_0").draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Text using an SDF font", 2);
_element.font("spr_msdf_openhuninn").draw(_x, _y);
_y += _element.get_height() + 10;