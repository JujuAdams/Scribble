var _element = scribble("abcdefghijklmnopqrstuvwxyz0123456789");
draw_set_font(scribble_fallback_font);
draw_text(10, 10, typist.get_position());
_element.draw(10, 30, typist);

var _x = 10 + floor(typist.get_position())*scribble_glyph_get("fnt_monospace", " ", SCRIBBLE_GLYPH_WIDTH);
draw_line(_x, 30, _x, 30 + scribble_glyph_get("fnt_monospace", " ", SCRIBBLE_GLYPH_HEIGHT));