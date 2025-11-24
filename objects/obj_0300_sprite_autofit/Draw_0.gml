draw_set_font(fntScribbleFallback);
draw_text(10, 10, $"SCRIBBLE_SPRITE_SCALE_MIN = {SCRIBBLE_SPRITE_SCALE_MIN}, SCRIBBLE_SPRITE_SCALE_MAX = {SCRIBBLE_SPRITE_SCALE_MAX}");

scribble("[spr_large_coin] <-- This is a big coin\n[spr_large_coin] <-- And another").draw(10, 40);
scribble("[spr_coin] <-- This is a small coin").draw(10, 90);
