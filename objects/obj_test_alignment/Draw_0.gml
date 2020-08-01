draw_set_colour(c_red);
draw_line(480, 0, 480, room_height);

draw_line(0, 200, 480, 200);
draw_line(0, 270, 480, 270);
draw_line(0, 340, 480, 340);

scribble_set_box_align(fa_left, fa_top);
var _scribble = scribble_draw(480, 200, "[fa_center][fa_bottom][[fa_center] + box align fa_left fa_bottom");
draw_text(10, 10, string(_scribble[SCRIBBLE.MIN_X]) + " -> " + string(_scribble[SCRIBBLE.MAX_X]));

scribble_set_box_align(fa_center, fa_top);
var _scribble = scribble_draw(480, 270, "[fa_center][fa_middle][[fa_center] + box align fa_center fa_middle");
draw_text(10, 30, string(_scribble[SCRIBBLE.MIN_X]) + " -> " + string(_scribble[SCRIBBLE.MAX_X]));

scribble_set_box_align(fa_right, fa_top);
var _scribble = scribble_draw(480, 340, "[fa_center][fa_top][[fa_center] + box align fa_right fa_top");
draw_text(10, 50, string(_scribble[SCRIBBLE.MIN_X]) + " -> " + string(_scribble[SCRIBBLE.MAX_X]));

scribble_reset();