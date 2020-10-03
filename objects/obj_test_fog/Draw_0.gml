scribble_set_fog(c_fuchsia, lerp(0, 1, 0.5 + 0.5*dsin(current_time/30)));
scribble_draw(room_width/2, room_height/2, "[fa_center][fa_middle]This is a fogging effect! [spr_large_coin,0]");
scribble_reset();