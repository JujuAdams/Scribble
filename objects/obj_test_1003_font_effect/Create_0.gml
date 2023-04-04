var _mapstring = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
font_add_sprite_ext(spr_sprite_font, _mapstring, true, 0);

scribble_font_bake_effects("spr_sprite_font", "outline 4", 1, 4, 0, 0, false);
scribble_font_bake_effects("spr_sprite_font", "outline 8", 1, 8, 0, 0, false);
scribble_font_bake_effects("spr_sprite_font", "shadow",    0, 0, 1, 1, false);
scribble_font_bake_effects("spr_sprite_font", "both",      1, 4, 1, 1, false);