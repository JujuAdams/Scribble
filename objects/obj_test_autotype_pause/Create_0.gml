scribble_init("Fonts", "fnt_test_2");
scribble_add_fonts_auto();

element = scribble_cache("abcdefg[pause]hijklmnop");
scribble_autotype_fade_in(element, 0.12, 10, false);