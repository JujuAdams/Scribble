element.draw(10, 10);

var _x = 10 + floor(element.typist_get_position())*scribble_glyph_get("fnt_monospace", " ", SCRIBBLE_GLYPH_WIDTH);
draw_line(_x, 10, _x, 10 + scribble_glyph_get("fnt_monospace", " ", SCRIBBLE_GLYPH_HEIGHT));

draw_text(10, element.get_height() + 20, element.typist_get_position());
draw_text(10, element.get_height() + 50, element.typist_get_debug_info());