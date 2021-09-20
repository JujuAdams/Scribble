scribble_font_add_all();
scribble_font_set_default("fnt_test_1");

scribble_glyph_set("fnt_test_1", "b", SCRIBBLE_GLYPH.WIDTH,  2*scribble_glyph_get("fnt_test_1", "b", SCRIBBLE_GLYPH.WIDTH ), false);
scribble_glyph_set("fnt_test_1", "b", SCRIBBLE_GLYPH.HEIGHT, 2*scribble_glyph_get("fnt_test_1", "b", SCRIBBLE_GLYPH.HEIGHT), false);
scribble_glyph_set("fnt_test_1", "j", SCRIBBLE_GLYPH.SEPARATION, 5, true);
scribble_glyph_set("fnt_test_1", "u", SCRIBBLE_GLYPH.Y_OFFSET, -5, true);
scribble_glyph_set("fnt_test_1", "p", SCRIBBLE_GLYPH.X_OFFSET, -5, true);