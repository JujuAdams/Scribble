scribble_blend_sprites_set(!keyboard_check(vk_space));

draw_set_font(scribble_fallback_font);
draw_text(10, 10, "scribble_blend_sprites_get() = " + string(scribble_blend_sprites_get()));

scribble(@"[spr_coin] <-- basic animation
[c_red][spr_white_coin] <-- red coin![/]
[rainbow][spr_white_coin] <-- rainbow coin![/]
[cycle, 60, 100, 0, 200][spr_white_coin] <-- colour cycle coin!
[scale,2][spr_vertical_spacing][/scale] <-- vertically spaced sprite").draw(x, y);
