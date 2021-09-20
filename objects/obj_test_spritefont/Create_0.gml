var _proportional = true;

scribble_font_set_default("spr_sprite_font");

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
spritefont = font_add_sprite_ext(spr_sprite_font, _mapstring, _proportional, 0);
if (_proportional) scribble_glyph_set("spr_sprite_font", " ", SCRIBBLE_GLYPH.SEPARATION, 11);

//Native GM defintions
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
test_string = "The Quick Brown Fox Jumps Over The Lazy Dog!";