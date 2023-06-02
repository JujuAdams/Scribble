var _string = "Juju Adams";

draw_set_font(fnt_hanoded_hand);
draw_text(x, y - 50, _string);
draw_text_scribble_ext(x, y + 50, _string, wrap_x);

draw_line(x + wrap_x, 0, x + wrap_x, room_height);