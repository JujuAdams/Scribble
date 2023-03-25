var _string = "Lorem ipsum dolor sit amet,\n\nconsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

scribble(_string).wrap(400)
.align(fa_center, fa_middle)
.crop(crop_l, crop_t, crop_r, crop_b)
.draw(room_width/2, room_height/2);

draw_rectangle(crop_l, crop_t, crop_r, crop_b, true);