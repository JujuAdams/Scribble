scribble_font_set_default("fnt_style");

scribble_super_create("fnt_overwrite_test");
scribble_super_glyph_copy_all("fnt_overwrite_test", "fnt_test_0", true);
scribble_super_glyph_copy_all("fnt_overwrite_test", "fnt_test_1", true);

scribble_super_create("fnt_mixed_languages_test");
scribble_super_glyph_copy_all("fnt_mixed_languages_test", "fnt_noto_latin", false);
scribble_super_glyph_copy_all("fnt_mixed_languages_test", "fnt_noto_chinese", false);
scribble_super_glyph_copy_all("fnt_mixed_languages_test", "fnt_noto_japanese", false);