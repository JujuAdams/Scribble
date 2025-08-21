draw_set_font(scribble_fallback_font);
draw_text(10, 10, typist.get_delay_paused());

scribble(test_string).allow_glyph_data_getter().draw(x, y, typist);