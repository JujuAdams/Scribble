var _string = "Style test!\n[b]Style test!\n[i]Style test!\n[bi]Style test!";

scribble_set_box_align(fa_center, fa_middle);
scribble_draw(room_width div 2, room_height div 2, _string);
scribble_reset();