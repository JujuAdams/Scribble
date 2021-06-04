scribble_font_set_default("fnt_test_0");

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_font_add_from_sprite("spr_sprite_font", _mapstring, 0, 3);

scribble_font_bake_outline("spr_sprite_font", "outline_font", 1, 4, c_red, false);