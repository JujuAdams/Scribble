//Example looks nicer with interpolation on!
gpu_set_tex_filter(true);

scribble_font_set_default("fnt_test_1");

var _mapstring = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
font_add_sprite_ext(spr_sprite_font, _mapstring, true, 1);
scribble_font_force_bilinear_filtering("spr_sprite_font", false);

//Create a "typist" which holds typewriter state
typist = scribble_typist();
typist.in(0.08, 60);
typist.ease(SCRIBBLE_EASE.ELASTIC, 0, -25, 1, 1, 0, 0.1);