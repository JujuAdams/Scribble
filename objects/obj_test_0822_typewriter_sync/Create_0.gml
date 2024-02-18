sound = audio_play_sound(snd_sync_test, 0, false);

typist = scribble_typist_legacy();
typist.TypeIn(0.4, 30, false);
typist.TypeEase(SCRIBBLE_EASE.BOUNCE, 0, 0, 1.5, 1.5, 0, 0);
typist.TypeSyncToSound(sound);