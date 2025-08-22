scribble_font_set_default("fnt_test_1");

scribble_glyph_set("fnt_test_1", "b", SCRIBBLE_GLYPH_WIDTH,  2*scribble_glyph_get("fnt_test_1", "b", __SCRIBBLE_GLYPH_PROPR_WIDTH ), false);
scribble_glyph_set("fnt_test_1", "b", SCRIBBLE_GLYPH_HEIGHT, 2*scribble_glyph_get("fnt_test_1", "b", __SCRIBBLE_GLYPH_PROPR_HEIGHT), false);
scribble_glyph_set("fnt_test_1", "j", SCRIBBLE_GLYPH_SEPARATION, 5, true);
scribble_glyph_set("fnt_test_1", "u", SCRIBBLE_GLYPH_Y_OFFSET, -5, true);
scribble_glyph_set("fnt_test_1", "p", SCRIBBLE_GLYPH_X_OFFSET, -5, true);