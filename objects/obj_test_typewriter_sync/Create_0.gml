sound = audio_play_sound(snd_sync_test, 0, false);

element = scribble_unique("[sync,1.46]Beep... [sync,2.63]Beep... [sync,3.76]Beep... [sync,4.98]Beep...")
element.in(0.4, 30);
element.ease(SCRIBBLE_EASE_BOUNCE, 0, 0, 1.5, 1.5, 0, 0);
element.sync_to_sound(sound);