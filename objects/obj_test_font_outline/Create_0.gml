scribble_font_set_default("spr_sprite_font_outlined");

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
font_add_sprite_ext(spr_sprite_font, _mapstring, false, 0);

scribble_glyph_set("spr_sprite_font", " ", SCRIBBLE_GLYPH.SEPARATION, 5);
scribble_glyph_set("spr_sprite_font", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_glyph_set("spr_sprite_font", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

scribble_font_bake_outline("spr_sprite_font", "spr_sprite_font_outlined", 3, 4, c_red, false);