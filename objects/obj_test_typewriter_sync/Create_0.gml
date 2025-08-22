sound = audio_play_sound(snd_sync_test, 0, false);

typist = scribble_typist();
typist.in(0.4, 30);
typist.ease(SCRIBBLE_EASE_BOUNCE, 0, 0, 1.5, 1.5, 0, 0);
typist.sync_to_sound(sound);