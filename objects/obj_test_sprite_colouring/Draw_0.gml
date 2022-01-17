draw_set_font(scribble_fallback_font);
draw_text(10, 10, "SCRIBBLE_COLORIZE_SPRITES = " + string(SCRIBBLE_COLORIZE_SPRITES));

scribble("[spr_coin] <-- basic animation\n[c_red][spr_white_coin] <-- red coin![/]\n[rainbow][spr_white_coin] <-- rainbow coin![/]\n[cycle, 60, 100, 0, 200][spr_white_coin] <-- colour cycle coin!").draw(x, y);