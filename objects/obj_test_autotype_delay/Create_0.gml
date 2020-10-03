scribble_set_default_font("fnt_test_2");
scribble_add_all_fonts();

element = scribble_cache("abcdefg[delay]hijklmnop");
scribble_autotype_fade_in(element, 0.05, 0, false);