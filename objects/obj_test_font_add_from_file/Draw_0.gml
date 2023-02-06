draw_clear(c_black);

var _str = "hello";

scribble(_str).draw(10, 10);

draw_set_font(font);
draw_text(10, 200, _str);
draw_text(300, 10, _str);

shader_set(shd_passthrough);
draw_text(300, 200, _str);
shader_reset();