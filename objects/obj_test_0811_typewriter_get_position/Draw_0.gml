var _element = scribble("abcdefghijklmnopqrstuvwxyz0123456789");
draw_set_font(scribble_fallback_font);
draw_text(10, 10, typist.GetTypePosition());
_element.draw(10, 30, typist);

var _x = 10 + floor(typist.GetTypePosition())*scribble_glyph_width_get("fnt_monospace", " ");
draw_line(_x, 30, _x, 30 + scribble_glyph_height_get("fnt_monospace", " "));