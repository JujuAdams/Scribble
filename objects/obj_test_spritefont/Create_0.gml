scribble_font_set_default("spr_sprite_font");
scribble_font_add_all();

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_font_add_from_sprite("spr_sprite_font", _mapstring, 0, 11);

scribble_glyph_set("spr_sprite_font", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_glyph_set("spr_sprite_font", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

//Native GM defintions
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
test_string = "The Quick Brown Fox Jumps Over The Lazy Dog!";
spritefont = font_add_sprite_ext(spr_sprite_font, _mapstring, true, 0);