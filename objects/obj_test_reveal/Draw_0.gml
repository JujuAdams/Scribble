var _string = "some manual typewriter text!";
var _element = scribble(_string).allow_glyph_data_getter();
var _pos = (mouse_x / room_width)*_element.get_reveal_count();

draw_set_font(fntScribbleFallback);
draw_text(10, 10, "reveal = " + string(_pos) + " of " + string(string_length(_string)));

_element.draw(10, 50, _pos);

var _bbox = _element.get_bbox_revealed(10, 50, _pos);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);