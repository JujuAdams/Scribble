draw_set_font(spritefont);
draw_text(10, 10, test_string);
scribble("[spr_sprite_font]!" + test_string).draw(10 + string_width(test_string), 10);
scribble("[spr_sprite_font]" + test_string).draw(10, 30);
draw_set_font(-1);