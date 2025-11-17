var _element = scribble(text).clip().max_size(maxWidth, maxHeight);
//_element.align(fa_left,   fa_top   ).draw(10, 10);
//_element.align(fa_center, fa_middle).draw(room_width div 2, room_height div 2);
_element.align(fa_right,  fa_bottom).draw(room_width-10, room_height-10);

draw_rectangle(10, 10, 10 + maxWidth, 10 + maxHeight, true);

draw_set_halign(fa_right);
//draw_text(room_width-10, 10, $"{maxWidth}x{maxHeight}");
draw_set_halign(fa_left);