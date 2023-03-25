scribble("[fa_center][fa_middle]Here's some text, [scale,2]here's some large text,[scale,0.5] here's some small text\n\n[scale,0.5]0.5 [scaleStack,2]1.0 [/scale]1.0")
.layout_wrap(750)
.draw(room_width div 2, room_height div 2);

draw_set_alpha(0.5);
draw_line(room_width/2, 0, room_width/2, room_height);
draw_line(0, room_height/2, room_width, room_height/2);
draw_set_alpha(1.0);