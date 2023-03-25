draw_set_colour(c_red);
draw_line(480, 0, 480, room_height);

scribble("[fa_left]Here's some text ---------------[pin_right]Right pinned[pin_center]Centre pin").draw(480, 30);

scribble("[pin_right]But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.")
.layout_wrap(400)
.draw(room_width - 400, 180);