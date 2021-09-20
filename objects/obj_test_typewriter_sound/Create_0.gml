scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

typist = scribble_typist();
typist.in(1, 0, false);
typist.sound_per_char(snd_crank, 1.0, 1.0); //THIS GETS LOUD