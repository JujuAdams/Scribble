//Example looks nicer with interpolation on!
gpu_set_tex_filter(true);

//Set the default font
scribble_font_set_default("fnt_test_1");

//Add a new spritefont
var _mapstring = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
font_add_sprite_ext(spr_sprite_font, _mapstring, true, 1);

//Force this font to not use bilinear filtering
scribble_font_force_bilinear_filtering("spr_sprite_font", false);

//Create a new font based on the spritefont but with a drop shadow
scribble_font_bake_outline_and_shadow("spr_sprite_font", "spr_sprite_font_outlined", 1, 1, SCRIBBLE_OUTLINE.NO_OUTLINE, 0, false);

//Create a "typist" which holds typewriter state
typist = scribble_typist();
typist.in(0.8, 60);
typist.ease(SCRIBBLE_EASE.ELASTIC, 0, -25, 1, 1, 0, 0.1);