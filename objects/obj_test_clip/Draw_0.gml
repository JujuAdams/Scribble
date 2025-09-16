scribble("Draw event\n" + text).clip().max_size(maxWidth, maxHeight).transform(1, 1, -10).draw(10, 10);

draw_rectangle(10, 10, 10 + maxWidth, 10 + maxHeight, true);

draw_set_halign(fa_right);
draw_text(room_width-10, 10, $"{maxWidth}x{maxHeight}");
draw_set_halign(fa_left);