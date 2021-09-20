scribble_font_set_default("fnt_test_2");

typist = scribble_typist();
typist.in(0.4, 20);
typist.ease(SCRIBBLE_EASE.BOUNCE, 0, -30, 1, 1, 0, 0.1);