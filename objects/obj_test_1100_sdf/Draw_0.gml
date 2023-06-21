var _scale = lerp(1, 7, mouse_x / room_width);

draw_set_font(fnt_industrydemi);
draw_text_transformed(10, 10, "Hello world", _scale, _scale, 0);

scribble("Hello world").post_transform(_scale).draw(10, 10 + _scale*string_height("Hello world"));

draw_set_font(-1);