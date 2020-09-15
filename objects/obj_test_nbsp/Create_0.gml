scribble_init("", "fnt_test_0", true);

scribble_set_wrap(100, -1);
element = scribble_cache("1 2 3 4 5 6 7 8[nbsp]9 0 a b c d e f g h i");
scribble_reset();

scribble_autotype_fade_in(element, 1, 10, false);