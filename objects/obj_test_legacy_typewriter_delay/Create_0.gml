scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

element = scribble("abcdefg[delay]hijklmnop");
element.typewriter_in(0.05, 0, false);