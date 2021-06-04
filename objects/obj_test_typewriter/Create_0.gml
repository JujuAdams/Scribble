scribble_font_set_default("fnt_test_2");

typist = scribble_typist();
typist.in(0.2, 10);
typist.ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);