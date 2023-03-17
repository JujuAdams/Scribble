global.font_add_font = scribble_font_add("NotoSans", "NotoSans-Regular.ttf", 20, 32, 127, false);
draw_set_font(global.font_add_font);
scribble_font_set_default("NotoSans");

scribble_font_fetch("NotoSans", [33, 127]);

glyph = 74;

alarm_delay = 10;
alarm[0] = alarm_delay;