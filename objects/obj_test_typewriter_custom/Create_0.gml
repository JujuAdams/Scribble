scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

element = scribble("abcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz\n");
element.typewriter_in(0.4, 20);
element.typewriter_ease(SCRIBBLE_EASE.BOUNCE, 0, -30, 1, 1, 0, 0.1);