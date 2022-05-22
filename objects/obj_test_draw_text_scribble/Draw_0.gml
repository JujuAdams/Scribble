draw_circle(room_width/2, room_height/3, 10, true);
scribble("scribble()").draw(room_width/2, room_height/3);

draw_set_color(c_black);
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_circle(room_width/2, room_height*2/3, 10, true);


draw_text_scribble_ext(room_width/2, room_height*2/3, "draw_text_scribble()", mouse_x);

var _width  = string_width_scribble_ext( "draw_text_scribble()", mouse_x);
var _height = string_height_scribble_ext("draw_text_scribble()", mouse_x);
draw_rectangle(room_width/2 - _width, room_height*2/3 - _height, room_width/2, room_height*2/3, true);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);