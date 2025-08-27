scribble("[spr_sprite_font][scale,3]T")
.wrap(room_width - 20)
.outline(c_red)
.blend(c_black)
.draw(10, 50);

draw_circle(10, 50, 10, true);

draw_set_font(spritefont);
draw_text_transformed(50, 50, "T", 3, 3, 0);
draw_set_font(-1);

scribble("[spr_sprite_font][scale,3]The Quick Brown Fox Jumps Over The Lazy Dog!")
.wrap(room_width - 20)
.draw(10, 300);

draw_circle(10, 300, 10, true);