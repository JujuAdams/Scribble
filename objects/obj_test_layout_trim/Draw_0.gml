var _timer = get_timer();
scribble(text, "A").layout_trim_ellipsis().max_size(maxWidth, maxHeight).draw(10, 10);
scribble(text, "B").layout_trim().max_size(maxWidth, maxHeight).draw(20 + maxWidth, 10);
smoothedTime = lerp(smoothedTime, get_timer() - _timer, 0.02);

draw_rectangle(10, 10, 10 + maxWidth, 10 + maxHeight, true);
draw_rectangle(20 + maxWidth, 10, 20 + 2*maxWidth, 10 + maxHeight, true);

draw_set_halign(fa_right);
draw_text(room_width-10, 10, $"{maxWidth}x{maxHeight}");
draw_set_halign(fa_left);