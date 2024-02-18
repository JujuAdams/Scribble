sound = audio_play_sound(snd_sync_test, 0, false);

typist = scribble_typist_legacy();
typist.in(0.4, 30, false);
typist.ease(SCRIBBLE_EASE.BOUNCE, 0, 0, 1.5, 1.5, 0, 0);
typist.sync_to_sound(sound);