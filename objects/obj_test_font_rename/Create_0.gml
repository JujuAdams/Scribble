var _mapstring = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
spritefont = font_add_sprite_ext(spr_sprite_font, _mapstring, true, 1);
scribble_font_rename("spr_sprite_font", "fnt_new_name");
scribble_font_set_default("fnt_new_name");