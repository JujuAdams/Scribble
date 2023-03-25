draw_set_font(scribble_fallback_font);
draw_text(10, 10, "SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE = " + string(SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE));

scribble("[scale,5]iiiii!").font("spr_sprite_font").draw(10,  50);
scribble("[scale,5]Hiiii!").font("spr_sprite_font").draw(10, 110);

scribble("[scale,5]!!!!!").font("scribble_fallback_font").draw(10, 210);
scribble("[scale,5]H!!!!").font("scribble_fallback_font").draw(10, 310);

draw_line(10, 50, 10, room_height);

scribble("[scale,5]jjjj").font("spr_msdf_openhuninn").draw(450,  50);
scribble("[scale,5]Hjjj").font("spr_msdf_openhuninn").draw(450, 150);

draw_line(450, 50, 450, room_height);