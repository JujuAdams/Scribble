scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

scribble_typewriter_add_character_delay(".", 1000);

streamAudioID = audio_create_stream("snd_evil_laugh.ogg");
scribble_external_audio_add("snd_evil_laugh", streamAudioID);

element = scribble("[snd_evil_laugh]abcdef abcdef abcdef.");
element.typewriter_in(0.2, 0, false);