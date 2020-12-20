scribble("[fa_center][fa_middle]This is a fogging effect! [spr_large_coin,0]")
.fog(c_fuchsia, lerp(0, 1, 0.5 + 0.5*dsin(current_time/10)))
.draw(room_width/2, room_height/2);