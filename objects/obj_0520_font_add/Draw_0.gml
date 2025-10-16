// Feather disable all

var _string = "Hello World";

scribble(_string).font(dynamicFont).draw(10, 10);
scribble(_string).font(fnt_dialogue_2).draw(10, 30);

draw_set_font(dynamicFont);
draw_text(120, 10, _string);

draw_set_font(fnt_dialogue_2);
draw_text(120, 30, _string);

scribble(_string, "bigger").font(dynamicFont).transform(3, 3, 0).sdf_outline(c_black, 2).draw(10, 70);

draw_set_font(dynamicFont);
draw_text_transformed(10, 140, _string, 3, 3, 0);

draw_set_font(fnt_dialogue_2);
draw_text_transformed(10, 210, _string, 3, 3, 0);