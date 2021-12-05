draw_text(10, 10, "SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE = " + string(SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE));

scribble("[scale,5]iiiii!").starting_format("spr_sprite_font").draw(10,  50);
scribble("[scale,5]Hiiii!").starting_format("spr_sprite_font").draw(10, 110);

scribble("[scale,5]!!!!!").starting_format("scribble_fallback_font").draw(10, 210);
scribble("[scale,5]H!!!!").starting_format("scribble_fallback_font").draw(10, 310);

draw_line(10, 50, 10, room_height);

scribble("[scale,5]jjjj").starting_format("spr_msdf_openhuninn").draw(450,  50);
scribble("[scale,5]Hjjj").starting_format("spr_msdf_openhuninn").draw(450, 150);

draw_line(450, 50, 450, room_height);