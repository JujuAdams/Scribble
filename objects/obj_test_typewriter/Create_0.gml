scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

element = scribble("here's[delay] some[delay] cute[delay] text!");
element.typewriter_in(0.2, 10);
element.typewriter_ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);