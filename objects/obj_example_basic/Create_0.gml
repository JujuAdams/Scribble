scribble_font_add_from_sprite("spr_sprite_font", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß", 0, 5);
scribble_font_set_default("fnt_test_1");

//Create a "typist" which holds typewriter state
typist = scribble_typist();
typist.in(0.8, 60);
typist.ease(SCRIBBLE_EASE.ELASTIC, 0, -25, 1, 1, 0, 0.1);