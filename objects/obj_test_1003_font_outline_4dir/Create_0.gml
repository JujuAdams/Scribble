scribble_font_set_default("spr_sprite_font_outlined");

var _mapstring = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
font_add_sprite_ext(spr_sprite_font, _mapstring, true, 0);

scribble_font_bake_outline_4dir("spr_sprite_font", "spr_sprite_font_outlined", c_red, false, 256);