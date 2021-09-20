scribble_font_set_default("fnt_test_2");

element = scribble("here's[delay] some[delay] cute[delay] text! [spr_large_coin]");
element.typewriter_in(0.2, 10);
element.typewriter_ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);