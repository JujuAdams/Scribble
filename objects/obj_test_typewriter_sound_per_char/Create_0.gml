element = scribble_unique("abc def.").allow_glyph_data_getter();
element.in(0.1, 0);
element.sound_per_char(snd_crank, 1.0, 1.0, " ", 1, true); //THIS GETS LOUD