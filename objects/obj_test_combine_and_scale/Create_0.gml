scribble_font_set_default("fnt_test_1");
scribble_font_scale("fnt_test_1", 2, 2);

scribble_font_collage_create("fnt_mixed_test");
scribble_font_collage_glyph_copy_all("fnt_mixed_test", "fnt_test_1", true);
scribble_font_collage_glyph_copy_all("fnt_mixed_test", "fnt_noto_japanese", false);