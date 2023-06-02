var _string = "Juju Adams";

var _x = room_width/2;
var _y = room_height/2;

draw_set_font(fnt_hanoded_hand);
draw_text(_x, _y - 50, _string);
draw_text_scribble_ext(_x, _y + 50, _string, mouse_x - _x);