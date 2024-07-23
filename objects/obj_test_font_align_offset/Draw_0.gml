draw_set_colour(c_red);
draw_line(480, 0, 480, room_height);

draw_line(0, 200, 480, 200);
draw_line(0, 270, 480, 270);
draw_line(0, 340, 480, 340);

scribble("[fa_left][fa_bottom][scale,3]fa_left [spr_coin] fa_bottom").draw(480, 200);
scribble("[fa_center][fa_middle][scale,3]fa_center [spr_coin] fa_middle").draw(480, 270);
scribble("[fa_right][fa_top][scale,3]fa_right [spr_coin] fa_top").draw(480, 340);