//Start up Scribble and load fonts automatically from Included Files
scribble_font_set_default("fnt_test_0");
scribble_font_add_all();

//Add a spritefont to Scribble
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_font_add_from_sprite("spr_sprite_font", _mapstring, 0, 3);

//Some characters need a bit of fine adjustment in code since it's not always possible to fix this in the font itself
scribble_glyph_set("spr_sprite_font", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_glyph_set("spr_sprite_font", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

smoothed_time = 1000;