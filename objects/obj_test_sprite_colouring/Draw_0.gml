draw_set_font(scribble_fallback_font);
draw_text(10, 10, "SCRIBBLE_COLORIZE_SPRITES = " + string(SCRIBBLE_COLORIZE_SPRITES));

scribble(@"[spr_coin] <-- basic looping animation
[spr_coin,-1] <-- once animation
[c_red][spr_white_coin] <-- red coin![/]
[rainbow][spr_white_coin] <-- rainbow coin![/]
[cycle, test][spr_white_coin] <-- colour cycle coin!
[scale,2][spr_vertical_spacing][/scale] <-- vertically spaced sprite").draw(x, y);