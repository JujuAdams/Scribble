scribble_set_default_font("fnt_test_0");
scribble_add_all_fonts();

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("spr_sprite_font", _mapstring, 0, 3);

scribble_bake_outline("spr_sprite_font", "outline_font", 1, 4, c_red, false);