scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

scribble_typewriter_add_character_delay(".", 1000);

// Loading in an ogg file and assigning it to Scribbles External Sound Database for it to be used with the typewriter.
streamSoundID = audio_create_stream("snd_crank_ext.ogg");
scribble_external_sound_add("snd_crank_ext", streamSoundID);

element = scribble("abcdef abcdef abcdef.");
element.typewriter_in(0.2, 0, false);
//element.typewriter_sound_per_char(scribble_external_sound_get_index("snd_crank_ext"), 1.0, 1.0); //THIS GETS LOUD