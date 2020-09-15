scribble_init("", "fnt_test_0", true);
scribble_add_color("yellow", make_color_rgb(255, 226, 92), true);

scribble_add_msdf_font("riffic", 12);
scribble_set_glyph_property("riffic", "W", SCRIBBLE_GLYPH.SEPARATION, -1, true);

scribble_add_msdf_font("riffic2", 12);
//scribble_set_glyph_property("riffic2", all, SCRIBBLE_GLYPH.SEPARATION, 1, true);
scribble_set_glyph_property("riffic2", "4", SCRIBBLE_GLYPH.SEPARATION, 5, true);