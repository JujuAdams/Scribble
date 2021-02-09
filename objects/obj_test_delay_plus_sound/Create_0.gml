scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

scribble_typewriter_add_character_delay(".", 1000);

element = scribble("abcdef abcdef abcdef.");
element.typewriter_in(0.2, 0, false);
//element.typewriter_sound_per_char(snd_crank, 1.0, 1.0); //THIS GETS LOUD