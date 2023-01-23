scribble_font_set_default("fnt_test_1");

scribble_super_create("target_font");
scribble_super_glyph_copy_all("target_font", "fnt_test_1", true);