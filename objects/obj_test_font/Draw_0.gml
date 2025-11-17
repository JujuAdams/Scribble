var _x = 10;
var _y = 10;

var _element = scribble("Text that uses the default font");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Text using a smaller font set by .font()");
_element.font("fnt_test_0").draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[fnt_test_0]The same but with in-line font change");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Setting a font with .font() but using a reference instead");
_element.font(fnt_test_0).draw(_x, _y);
_y += _element.get_height() + 10;

var _font = fnt_test_0;
var _element = scribble($"[{_font}]Setting an in-line font but using a stringified reference");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Text using an SDF font set by .font()");
_element.font("fnt_openhuninn_sdf").draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[fnt_openhuninn_sdf]The same but with in-line font change");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Default font [fnt_test_0]Small font [fnt_openhuninn_sdf]SDF font");
_element.draw(_x, _y);
_element.debug_draw_bbox(_x, _y, c_white, 0.5);
_y += _element.get_height() + 10;