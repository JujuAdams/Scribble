var _text = "[fa_middle][c_red]Hi world\nHi world Hi world";
var _element = scribble(_text).allow_glyph_data_getter();

var _glyphCount = _element.get_glyph_count();
var _reveal = min(_glyphCount, (_glyphCount+1)*mouse_x/room_width);
var _bbox = _element.get_bbox_revealed(300, 300, _reveal);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, false);

scribble(_text).draw(300, 300, _reveal);

draw_set_font(fntScribbleFallback);
draw_text(10, 10, string(_reveal) + " of " + string(_glyphCount));