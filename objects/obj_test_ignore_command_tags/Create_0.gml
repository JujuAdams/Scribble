scribble_init("fnt_test_0");
scribble_add_fonts_auto();

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("spr_sprite_font", _mapstring, 0, 3);

scribble_bake_outline("spr_sprite_font", "outline_font", 1, 4, c_red, false);