scribble(text).clip().max_size(maxWidth, maxHeight).draw(10, 10);

draw_rectangle(10, 10, 10 + maxWidth, 10 + maxHeight, true);

draw_set_halign(fa_right);
draw_text(room_width-10, 10, $"{maxWidth}x{maxHeight}\nscroll to {chr(ord("a") + targetLine)} ({targetLine})");
draw_set_halign(fa_left);