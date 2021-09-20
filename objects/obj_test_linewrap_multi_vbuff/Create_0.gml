scribble_font_set_default("fnt_test_1");

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
font_add_sprite_ext(spr_sprite_font, _mapstring, false, 0);
scribble_glyph_set("spr_sprite_font", " ", SCRIBBLE_GLYPH.SEPARATION, 5);

limit = 363;