if (!surface_exists(surface)) surface = surface_create(32, 32);

surface_set_target(surface);
draw_clear_alpha(c_black, 0.0);
var _x = ((current_time/20) mod 32);
draw_circle(_x - 32, 15, 16, true);
draw_circle(_x     , 15, 16, true);
draw_circle(_x + 32, 15, 16, true);
surface_reset_target();

scribble("[fa_center][fa_middle]Here's a sprite: [spr_large_coin,0]... Here's a surface: [surface," + string(surface) + "]")
.draw(room_width/2, room_height/2);