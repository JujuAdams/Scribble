var _string = "The Quick Brown Fox Jumps Over The Lazy Dog!";

draw_set_font(spritefont);
draw_text(10, 10, _string);
draw_set_font(-1);

scribble("[spr_sprite_font]!" + _string).draw(10 + string_width(_string), 10);
scribble("[spr_sprite_font]" + _string).draw(10, 30);