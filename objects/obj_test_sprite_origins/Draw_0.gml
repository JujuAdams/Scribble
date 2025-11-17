draw_set_font(fntScribbleFallback);
draw_text(10, 10, "SCRIBBLE_ADD_SPRITE_ORIGINS = " + string(SCRIBBLE_ADD_SPRITE_ORIGINS));

scribble("[c_red][spr_white_coin] <-- red coin![/]\n[rainbow][spr_white_coin] <-- rainbow coin![/]\n[cycle,test][spr_white_coin] <-- colour cycle coin!").draw(x, y);