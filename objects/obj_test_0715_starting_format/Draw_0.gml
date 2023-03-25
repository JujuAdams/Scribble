var _x = 10;
var _y = 10;

var _element = scribble_unique(0, "Here's a string, the style of which will be changed by .starting_format()");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(1, "Text in red");
_element.starting_format(undefined, c_red).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(2, "Text using a smaller font");
_element.starting_format("fnt_test_0", undefined).draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(3, "Text using an SDF font in lime green");
_element.starting_format("spr_msdf_openhuninn", c_lime).draw(_x, _y);
_y += _element.get_height() + 10;