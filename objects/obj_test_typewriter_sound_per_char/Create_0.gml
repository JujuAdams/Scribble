if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) return;

typist = scribble_typist();
typist.in(0.1, 0);
typist.sound_per_char(snd_crank, 1.0, 1.0, " "); //THIS GETS LOUD