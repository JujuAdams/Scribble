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
scribble_font_bake_outline_and_shadow("spr_sprite_font", "spr_sprite_font_outlined", 1, 1, SCRIBBLE_OUTLINE_NONE, 0, false);

//Create a unique text element that holds typewriter state
var _string = @"[fa_center][fa_middle][rainbow][wave]Welcome to Scribble 9![/]

Scribble is a multi-effects text engine designed to be fast, easy, and fun.

It supports[scale,2][spr_sprite_font_outlined] in-line font changes (and spritefonts!) [/]as well as in-line sprites[nbsp][spr_large_coin]. Scribble can do a [wheel]bunch[/wheel] of [jitter]effects[/jitter] without slowing down your game.

Other examples and test cases in this project file will show you what else Scribble can do including an in-built typewriter, the events system, SDF fonts, and more!";

element = scribble_unique(_string)
.wrap(850)
.shadow(c_black, 1)
.in(0.8, 60)
.ease(SCRIBBLE_EASE_ELASTIC, 0, -25, 1, 1, 0, 0.1);