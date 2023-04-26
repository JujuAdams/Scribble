var _string = "Lorem ipsum dolor sit amet,\n\nconsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

scribble(_string, 0)
.rgb_multiply(c_red)
.alpha(0.5)
.layout_wrap(400)
.align(fa_center, fa_top)
.draw(room_width/2, room_height/2);

scribble(_string, 1)
.layout_wrap(400)
.align(fa_center, fa_top)
.scroll_to_y(scroll_y, 100)
.draw(room_width/2, 100);

draw_line(0, scroll_y + room_height/2, 300, scroll_y + room_height/2);
draw_line(room_width - 300, scroll_y + room_height/2, room_width, scroll_y + room_height/2);
draw_line(0, scroll_y - 100 + room_height/2, 300, scroll_y - 100 + room_height/2);
draw_line(room_width - 300, scroll_y - 100 + room_height/2, room_width, scroll_y - 100 + room_height/2);