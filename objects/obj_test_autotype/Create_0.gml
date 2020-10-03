scribble_init("fnt_test_2");
scribble_add_fonts_auto();

element = scribble_cache("abcdefg[delay][snd_crank]hijklmnop");
scribble_autotype_fade_in(element, 0.05, 0, false);