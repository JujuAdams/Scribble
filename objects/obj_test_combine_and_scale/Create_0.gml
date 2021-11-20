scribble_font_set_default("fnt_test_1");
scribble_font_scale("fnt_test_1", 2, 2);

scribble_super_create("fnt_mixed_test");
scribble_super_glyph_copy_all("fnt_mixed_test", "fnt_test_1", true);
scribble_super_glyph_copy_all("fnt_mixed_test", "fnt_noto_japanese", false);