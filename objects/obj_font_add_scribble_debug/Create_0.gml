global.font_add_font = font_add("NotoSans-Regular.ttf", 20, false, false, 32, 127);
font_enable_sdf(global.font_add_font, true);
draw_set_font(global.font_add_font);

scribble_font_set_default("NotoSans-Regular.ttf");

glyph = 32;

alarm_delay = 10;
alarm[0] = alarm_delay;