scribble_set_msdf_shadow(c_black, 1, 0, 3);
scribble_set_msdf_border(c_black, 3);
scribble_set_msdf_aa(1.0);

scribble_draw(10, 10, "[scale,3]Hello World!\n[scale,0.5][riffic2]Hello World!");

scribble_draw(room_width/2, room_height/2 - 150, "[fa_center][fa_middle][riffic][yellow]48  [scale,2]Campbell");
scribble_draw(room_width/2, room_height/2 + 150, "[fa_center][fa_middle][riffic2][yellow]48  [scale,2]Campbell");