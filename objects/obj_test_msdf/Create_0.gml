scribble_init("", "fnt_test_0", true);
scribble_add_color("yellow", make_color_rgb(255, 226, 92), true);

scribble_add_msdf_font("riffic", spr_msdf_font, "msdf.json", 12);
scribble_set_glyph_property("riffic", "4", SCRIBBLE_GLYPH.SEPARATION, 5, true);