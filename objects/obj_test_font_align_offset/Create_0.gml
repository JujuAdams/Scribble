var _mapstring = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
spritefont = font_add_sprite_ext(spr_sprite_font, _mapstring, true, 1);
scribble_font_set_default("spr_sprite_font");
scribble_font_set_halign_offset("spr_sprite_font", fa_left, -1);
scribble_font_set_halign_offset("spr_sprite_font", fa_center, 2);
scribble_font_set_halign_offset("spr_sprite_font", fa_right, 1);
scribble_font_set_valign_offset("spr_sprite_font", fa_top, -3);
scribble_font_set_valign_offset("spr_sprite_font", fa_middle, -1);
scribble_font_set_valign_offset("spr_sprite_font", fa_bottom, 3);