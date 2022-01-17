var _string = "Lorem ipsum dolor sit amet,\n\nconsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

var _element = scribble(_string);
_element.wrap(width);
_element.draw(x, y);
_element.debug_draw_bbox(x, y);

//draw_circle(x, y, 6, true);
//draw_rectangle(x, y, x + width, y + _element.get_height(), true);

//draw_circle(room_width div 2, y + _element.get_height() + 40, 6, true);

//scribble(_string).wrap(width).draw(room_width div 2, y + _element.get_height() + 40);