scribble_font_add("NotoSans", "NotoSans-Regular.ttf", 20, [32, 127], true);
scribble_font_set_default("NotoSans");

scribble_super_create("spr_msdf_super_test");
scribble_super_glyph_copy_all("spr_msdf_super_test", "spr_msdf_openhuninn", true);
scribble_super_glyph_copy("spr_msdf_super_test", "spr_msdf_industrydemi", true, "abcdefghijklm");