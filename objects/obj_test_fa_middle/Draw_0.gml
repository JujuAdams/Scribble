var _test_text = "Generate noise?";

draw_set_font(fnt_segoe_ui_12);
draw_set_valign(fa_middle);
draw_text((room_width div 2) - 60, room_height div 2, _test_text);
draw_set_valign(fa_top);
draw_set_font(-1);

scribble(_test_text)
.starting_format("fnt_segoe_ui_12", c_white)
.align(fa_left, fa_middle)
.draw((room_width div 2) + 60, room_height div 2);