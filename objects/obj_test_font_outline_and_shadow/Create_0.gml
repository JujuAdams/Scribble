scribble_font_set_default("spr_sprite_font_outlined");

var _mapstring = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
spritefont = font_add_sprite_ext(spr_sprite_font, _mapstring, true, 1);

scribble_font_bake_outline_and_shadow("spr_sprite_font", "spr_sprite_font_outlined", 1, 1, SCRIBBLE_OUTLINE.EIGHT_DIR_THICK, 0, false);