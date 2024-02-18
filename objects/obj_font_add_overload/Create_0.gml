font_texture_page_size = 512;

global.font_add_font = scribble_font_add("NotoSans", "NotoSans-Regular.ttf", 40, SCRIBBLE_FONT_GROUP.BASIC_LATIN, true);
draw_set_font(global.font_add_font);
scribble_font_set_default("NotoSans");

source = "`12345678990-=qwertyuiop[]\\asdfghjkl;'zxcvbnm,./~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:\"ZXCVBNM<>?";

showDebug = false;