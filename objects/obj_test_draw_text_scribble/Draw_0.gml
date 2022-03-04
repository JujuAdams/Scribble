draw_circle(room_width/2, room_height/3, 10, true);
scribble("scribble()").draw(room_width/2, room_height/3);

draw_set_color(c_black);
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_circle(room_width/2, room_height*2/3, 10, true);
draw_text_scribble(room_width/2, room_height*2/3, "draw_text_scribble()");
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);