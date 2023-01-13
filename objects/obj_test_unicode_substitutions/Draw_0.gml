draw_set_font(scribble_fallback_font);
draw_text(10, 10, "SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS = " + string(SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS));

var _x = 10;
var _y = 50;

var _element = scribble("Bulk test: … – — ― ‘ ’ “ ” „ ‟ ;");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Here's another test—a test of the substitution behaviour");
_element.draw(_x, _y);
_y += _element.get_height() + 10;