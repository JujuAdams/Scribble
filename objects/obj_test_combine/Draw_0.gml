var _string = "[fnt_combined]a1b2c3d4e5\n[fnt_test_0]a[fnt_style_invalid]1[fnt_test_0]b[fnt_style_invalid]2[fnt_test_0]c[fnt_style_invalid]3[fnt_test_0]d[fnt_style_invalid]4[fnt_test_0]e[fnt_style_invalid]5";

scribble_set_box_align(fa_center, fa_middle);
scribble_draw(room_width div 2, room_height div 2, _string);
scribble_reset();