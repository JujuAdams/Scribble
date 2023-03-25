var _sound_id = audio_create_stream("blip.ogg");
scribble_external_sound_add(_sound_id, "external");

typist = scribble_typist();
typist.in(0.01, 1);