var _text = "[fa_middle][c_red]Hi world\nHi world Hi world";
var _element = scribble(_text);

var _glyph_count = _element.get_glyph_count();
var _reveal = min(_glyph_count, (_glyph_count+1)*mouse_x/room_width);
_element.reveal(_reveal);

var _bbox = _element.get_bbox_revealed(300, 300);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, false);

scribble(_text).draw(300, 300);

draw_set_font(scribble_fallback_font);
draw_text(10, 10, string(_reveal) + " of " + string(_glyph_count));