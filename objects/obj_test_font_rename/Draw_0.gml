var _string = "The Quick Brown Fox Jumps Over The Lazy Dog!";

draw_set_font(spritefont);
draw_text(10, 10, _string);
draw_set_font(-1);

scribble(_string).draw(10 + string_width(_string), 10);
scribble("[fnt_new_name]" + _string).draw(10, 30);