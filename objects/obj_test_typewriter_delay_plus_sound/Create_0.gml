element = scribble_unique("abcdef... abcdef abcdef.");
element.in(0.2, 0);
element.sound(snd_crank, 0, 1.0, 1.0);
element.character_delay_add(".", 1000);