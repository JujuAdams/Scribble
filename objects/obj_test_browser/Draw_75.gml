draw_set_font(fntScribbleFallback);
draw_set_colour(c_white);
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_text(room_width-10, room_height-10, string(index) + ": " + object_get_name(object_array[index]));
draw_set_halign(fa_left);
draw_set_valign(fa_top);