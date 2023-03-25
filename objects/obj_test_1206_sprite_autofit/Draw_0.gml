draw_set_font(scribble_fallback_font);
draw_text(10, 10, "SCRIBBLE_AUTOFIT_INLINE_SPRITES = " + string(SCRIBBLE_AUTOFIT_INLINE_SPRITES));

scribble("[spr_large_coin] <-- This is a big coin\n[spr_large_coin] <-- And another").draw(10, 40);
scribble("[spr_coin] <-- This is a small coin").draw(10, 90);
