var _element = scribble(test_string);
_element.draw(x, y);

var _bbox = _element.get_bbox(x, y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_set_font(fnt_thai);
draw_text(100, 200, StringThaiParse(test_string));