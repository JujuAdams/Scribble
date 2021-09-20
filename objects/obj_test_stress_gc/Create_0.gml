//Start up Scribble and load fonts automatically from Included Files
scribble_font_set_default("fnt_test_0");

//Add a spritefont to Scribble
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
font_add_sprite_ext(spr_sprite_font, _mapstring, false, 0);
//Some characters need a bit of fine adjustment in code since it's not always possible to fix this in the font itself
scribble_glyph_set("spr_sprite_font", " ", SCRIBBLE_GLYPH.SEPARATION, 3);
scribble_glyph_set("spr_sprite_font", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_glyph_set("spr_sprite_font", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

smoothed_time = 1000;

toggle = true;
test_text = "";
counter = 0;

show_debug_overlay(true);