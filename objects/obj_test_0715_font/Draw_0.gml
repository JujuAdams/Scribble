var _x = 10;
var _y = 10;

var _element = scribble_unique(0, "Here's a string, the style of which will be changed by .font()");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(1, "Text using a smaller font");
_element.font("fnt_test_0").draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(2, "Text using an SDF font");
_element.font("spr_msdf_openhuninn").draw(_x, _y);
_y += _element.get_height() + 10;