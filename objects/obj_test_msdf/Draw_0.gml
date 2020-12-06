scribble_draw(10, 10, "[scale,3]Hello World!\n[scale,0.5][riffic]Hello World!");


var _scale = lerp(0.5, 5, 0.5 + 0.5*dsin(current_time/30));
scribble_set_transform(_scale, _scale, 19);
scribble_draw(room_width/2, room_height/2, "[fa_center][fa_middle][riffic]Hello World!");
scribble_reset();