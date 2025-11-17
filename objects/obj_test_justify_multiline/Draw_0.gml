var _element = scribble("[fa_justify]Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
.max_size(500)
.layout_wrap();

_element.draw(10, 10);
_element.debug_draw_bbox(10, 10);

draw_line(10, 5, 510, 5);
draw_line(510, 5, 510, room_height);