scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

element = scribble("abcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz\n");
element.typewriter_in(0.4, 20);