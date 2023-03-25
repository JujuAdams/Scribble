var _string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

var _element = scribble(_string).layout_fit(width, height);
_element.draw(x, y);
draw_rectangle(_element.get_left(x), _element.get_top(y), _element.get_right(x), _element.get_bottom(y), true);

draw_circle(x, y, 6, true);
draw_rectangle(x, y, x + _element.get_width(), y + _element.get_height(), true);

draw_circle(room_width div 2, y + _element.get_height() + 40, 6, true);

var _element = scribble(_string).layout_fit(width, height);
_element.draw(room_width div 2, y + _element.get_height() + 40);

draw_set_colour(c_red);
draw_rectangle(x, y, x + width, y + height, true);
draw_set_colour(c_white);